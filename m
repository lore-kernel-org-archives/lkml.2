Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2DZSUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:20:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2DZSU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:20:26 -0400
Date: Thu, 26 Apr 2012 13:20:13 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francesco Saverio Schiavarelli <fschiava@libero.it>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 23/62] brcm80211: smac: resume transmit fifo upon receiving
 frames
Message-ID: <20120426182013.GD3639@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.950806348@linuxfoundation.org>
 <20120425223959.GA6243@burratino>
 <4F990BE8.60805@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F990BE8.60805@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arend van Spriel wrote:

> We decided to only submit the patch for the mainline version of the
> driver, but your changes on the staging driver look fine. So if this
> patch is accepted in stable it is
>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Thanks for looking it over.
