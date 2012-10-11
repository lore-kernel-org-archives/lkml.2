Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2JKK7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:59:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33698 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab2JKK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:59:24 -0400
Date: Thu, 11 Oct 2012 19:59:17 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 60/84] r8169: fix wake on lan setting for non-8111E.
Message-ID: <20121011105917.GC28546@kroah.com>
References: <20121011015417.017144658@linuxfoundation.org>
 <20121011015427.889586553@linuxfoundation.org>
 <20121011071550.GA27313@elie.Belkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011071550.GA27313@elie.Belkin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 12:15:50AM -0700, Jonathan Nieder wrote:
> Hi Greg,
> 
> Greg Kroah-Hartman wrote:
> 
> > commit d4ed95d796e5126bba51466dc07e287cebc8bd19 upstream.
> >
> > Only 8111E needs enable RxConfig bit 0 ~ 3 when suspending or
> > shutdowning for wake on lan.
> 
> Sounds sensible to me, but I haven't reviewed this --- e.g., I
> don't know what symptoms this addresses or what model they were
> experienced on.
> 
> Here's a patch to remove the reviewed-bys that seem to have been
> added by mistake.

Sorry, yes, I added your reviewed-by to the whole series, my fault.
I've now applied your patch removing them.

greg k-h
