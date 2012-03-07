Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2CGIgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:36:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:59267 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab2CGIga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:36:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115752230"
Date: Wed, 7 Mar 2012 10:36:31 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Dave Jones <davej@redhat.com>, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: use-after-free in bluetooth (hci_conn_hash_flush)
Message-ID: <20120307083627.GA3647@aemeltch-MOBL1>
References: <20120305221242.GA2008@redhat.com>
 <20120306085342.GA8432@aemeltch-MOBL1>
 <20120306152215.GA20793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306152215.GA20793@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Mar 06, 2012 at 10:22:15AM -0500, Dave Jones wrote:
> On Tue, Mar 06, 2012 at 10:53:44AM +0200, Andrei Emeltchenko wrote:
> 
>  > On Mon, Mar 05, 2012 at 05:12:42PM -0500, Dave Jones wrote:
>  > > We had a user report this, which looks like a use after free
>  > > in hci_conn_hash_flush(). Probably related to bf4c63252490ba78fb833cc7acf1a5b1900c970f
>  > 
>  > Yes most probably this is the reason.
>  > 
>  > > Full report is at https://bugzilla.redhat.com/show_bug.cgi?id=797590
>  > 
>  > Could you try following commit?
>  > 
>  > commit 3c4e0df028935618d052235ba85bc7079be13394
>  > Author: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>  > Date:   Thu Feb 2 10:32:17 2012 +0200
>  > 
>  >     Bluetooth: Use list _safe deleting from conn_hash_list
> 
> Could you attach the patch ? I'll throw it into a Fedora build for
> the user who saw this to test.

Please check those related patches here:

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=2a5a5ec620a29d4ba07743c3151cdf0a417c8f8c
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=3c4e0df028935618d052235ba85bc7079be13394

Best regards 
Andrei Emeltchenko 

