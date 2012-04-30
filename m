Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2D3FGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:06:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55620 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2D3FF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:05:57 -0400
Date: Sun, 29 Apr 2012 18:04:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 23/62] brcm80211: smac: resume transmit fifo upon receiving
 frames
Message-ID: <20120430010412.GB25022@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.950806348@linuxfoundation.org>
 <20120425223959.GA6243@burratino>
 <4F990BE8.60805@broadcom.com>
 <20120426182013.GD3639@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426182013.GD3639@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 01:20:13PM -0500, Jonathan Nieder wrote:
> Arend van Spriel wrote:
> 
> > We decided to only submit the patch for the mainline version of the
> > driver, but your changes on the staging driver look fine. So if this
> > patch is accepted in stable it is
> >
> > Acked-by: Arend van Spriel <arend@broadcom.com>
> 
> Thanks for looking it over.

Thanks for doing the work, now applied.

greg k-h
