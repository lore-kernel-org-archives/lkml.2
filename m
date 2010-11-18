Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0KRBtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 20:49:10 -0500
Received: from tango.0pointer.de ([85.214.72.216]:37246 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab0KRBtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 20:49:08 -0500
Date: Thu, 18 Nov 2010 02:48:48 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        Valdis.Kletnieks@vt.edu, linux-kernel <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118014848.GA7873@tango.0pointer.de>
References: <20101116171447.29336514@lxorguk.ukuu.org.uk>
 <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
 <20101116213622.GA17824@tango.0pointer.de>
 <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
 <20101116231023.GB27594@tango.0pointer.de>
 <25482.1290031268@localhost>
 <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
 <20101117235647.00766e32@lxorguk.ukuu.org.uk>
 <20101118012734.GA8558@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118012734.GA8558@kroah.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17.11.10 17:27, Greg KH (greg@kroah.com) wrote:

> I can do any one, or multiple things from the following options:
> 
> 	- disable the existing ioctl to return an error so that no new
> 	  userspace program starts to use it thinking it is valid
> 	- accept Werner's patch for those who like proc files
> 	- accept Kay's patch
> 
> Any suggestions?

Maybe this is not so surprising, but I definitely want item #3 from the
list. 

I am against #2, since #1 is a much nicer solution, and having both
would be needlessly redundant.

And #1 would be a good idea.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
