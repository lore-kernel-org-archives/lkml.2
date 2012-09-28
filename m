Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945979Ab2I1VGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:06:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38275 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965307Ab2I1VGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:06:07 -0400
X-Sasl-enc: 7BaIZKsgG+XBfBfINIn7HSJZ1F2xJfYDQ/BffWv+vzxb 1348866366
Date: Fri, 28 Sep 2012 14:05:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dick Streefland <dick.streefland@altium.nl>
Subject: Re: [ 089/262] SUNRPC: Fix a UDP transport regression
Message-ID: <20120928210503.GB25749@kroah.com>
References: <20120928182957.993484211@linuxfoundation.org>
 <20120928183008.625737819@linuxfoundation.org>
 <4FA345DA4F4AE44899BD2B03EEEC2FA908FF37D3@SACEXCMBX04-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA908FF37D3@SACEXCMBX04-PRD.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 07:46:57PM +0000, Myklebust, Trond wrote:
> On Fri, 2012-09-28 at 11:50 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > commit f39c1bfb5a03e2d255451bff05be0d7255298fa4 upstream.
> 
> Hi Greg,
> 
> Can we please hold on this one for now. It appears that it requires an
> extra initialiser in the 'bc_tcp_ops' declaration in
> net/sunrpc/xprtsock.c (to set '.alloc_slot = xprt_alloc_slot').
> 
> I have a separate patch for that, but it has not yet made it upstream.

Now dropped, thanks for letting me know.

greg k-h
