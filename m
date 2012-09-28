Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2I1VGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:06:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55281 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965286Ab2I1VGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:06:05 -0400
X-Sasl-enc: G9rmbkhFDuB+o9UZNlVEZ7gFQxKEKV/IWlhnxBkXa0Dg 1348866364
Date: Fri, 28 Sep 2012 14:04:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dick Streefland <dick.streefland@altium.nl>
Subject: Re: [ 070/218] SUNRPC: Fix a UDP transport regression
Message-ID: <20120928210427.GA25749@kroah.com>
References: <20120928201501.208384923@linuxfoundation.org>
 <20120928201509.596735923@linuxfoundation.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FF45E6@SACEXCMBX04-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA908FF45E6@SACEXCMBX04-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 08:29:37PM +0000, Myklebust, Trond wrote:
> On Fri, 2012-09-28 at 13:14 -0700, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > commit f39c1bfb5a03e2d255451bff05be0d7255298fa4 upstream.
> > 
> > Commit 43cedbf0e8dfb9c5610eb7985d5f21263e313802 (SUNRPC: Ensure that
> > we grab the XPRT_LOCK before calling xprt_alloc_slot) is causing
> > hangs in the case of NFS over UDP mounts.
> 
> Ditto with this. Please hold this patch until the 1 line fix mentioned
> previously has been merged upstream (at which point I will resend the
> patch through stable@vger.kernel.org).

Ok, now dropped from the 3.4-stable queue, please let me know when it's
safe to reapply.

greg k-h
