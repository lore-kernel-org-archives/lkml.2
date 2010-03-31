Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0CaSZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:25:33 -0400
Received: from lucidpixels.com ([75.144.35.66]:45918 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab0CaSZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:25:32 -0400
Date: Wed, 31 Mar 2010 14:25:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Tiago Vignatti <vignatti@freedesktop.org>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003310708330.8278@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003311419520.460@p34.internal.lan>
References: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan> <alpine.DEB.2.00.1003250833040.13307@p34.internal.lan> <alpine.DEB.2.00.1003250935030.21591@p34.internal.lan> <4BB286F5.9060706@freedesktop.org>
 <alpine.DEB.2.00.1003310708330.8278@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Mar 2010, Justin Piszcz wrote:


Hi,

With the latest BIOS, I used the system today for 1-2 hours and could not 
get it to repeat the crash (I had full debugging enabled) and Alan's patch 
applied, I will continue to test because when you want it to crash, it 
usually does not, but the BIOS update may have fixed it.

Latest BIOS for Dell Optiplex 740: 2.2.4 (upgraded today), it was upgraded 
from 2.0.12.

Justin.
