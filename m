Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1FPSCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:02:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab1FPSCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:02:44 -0400
Date: Thu, 16 Jun 2011 19:02:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de,
        stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Message-ID: <20110616180233.GN11521@ZenIV.linux.org.uk>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com>
 <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave>
 <4DFA3E1A.9050207@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFA3E1A.9050207@interlog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 01:32:10PM -0400, Douglas Gilbert wrote:

> As James' notes each storage device can only have one
> "preferred name" at a time. But how can that preferred name
> be represented in sysfs ? If /sys/block/<kernel_name>
> suddenly changed to /sys/block/<preferred_name> that would
> be very disruptive. I would prefer something like
> /sys/class/block_preferred_name/<preferred_name> was introduced
> as a symlink to /sys/block/<kernel_name> but that would require
> that all <preferred_name>s were unique. [Not a bad restriction
> IMO]. If the <preferred_name> was only placed in the
> /sys/block/<kernel_name> directory that would be ugly from
> the user space tool point of view.

Oh, rapture... so now we can expect the container crowd to introduce
yet *another* "namespace" ;-/
