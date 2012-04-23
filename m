Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2DWQtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:49:47 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62802 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab2DWQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:49:45 -0400
Date: Mon, 23 Apr 2012 09:49:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/8] PM: Implement autosleep and "wake locks", take 3
Message-ID: <20120423164940.GA10111@kroah.com>
References: <201202070200.55505.rjw@sisk.pl>
 <201202220031.46219.rjw@sisk.pl>
 <201204222319.02228.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204222319.02228.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 11:19:01PM +0200, Rafael J. Wysocki wrote:
> Hi all,
> 
> Following is the third update of the autosleep patchset.
> 
> Patches [1-4/8] are regarded as v3.5 material, the rest - depending on
> the feedback I get (lack of feedback will be understood as no objections,
> though).

This all looks great to me, thanks for continuing to push this:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

