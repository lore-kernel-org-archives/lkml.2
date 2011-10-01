Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1JAOJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:09:14 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36918 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755835Ab1JAOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:08:56 -0400
X-Sasl-enc: bfBx8N/ueROJ783jAn18Q2ux+LCCwiXBfSrTZns57UXv 1317478135
Date: Sat, 1 Oct 2011 07:07:20 -0700
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001140720.GA26674@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001073533.GA18690@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001073533.GA18690@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:35:33AM +0200, Willy Tarreau wrote:
> Hi Greg,
> 
> On Fri, Sep 30, 2011 at 04:59:24PM -0700, Greg KH wrote:
> > The compromise of kernel.org and related machines has made it clear that
> > some developers, at least, have had their systems penetrated.  As we
> > seek to secure our infrastructure, it is imperative that nobody falls
> > victim to the belief that it cannot happen to them.  We all need to
> > check our systems for intrusions.  Here are some helpful hints as
> > proposed by a number of developers on how to check to see if your Linux
> > machine might be infected with something:
> 
> I would like to add here a few controls I ran on firewall and system logs,
> that are easy to perform and which report few false positives :

<snip>

Thanks for this great list, it is much appreciated.

greg k-h
