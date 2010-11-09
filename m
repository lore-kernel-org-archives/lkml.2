Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0KIBhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:37:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64953 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab0KIBhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=frN8vSAos9SM9uVW+Lw3ADdmrE1XXDdRxAzjT1b1eYwWBuUhh/r0K7+uvjIfTPBf9g
         CJRSE44l+MxKagE2UAf1drk0s0/jgSzGqEo5zISsnDTR5Sp3ft/F1R3f1Y662ZXmiENI
         gTjKG8G4fL26itgBFv5xJ35kG3xB5p0/Uy4FE=
MIME-Version: 1.0
In-Reply-To: <1289265399.14461.1.camel@mola>
References: <1289265399.14461.1.camel@mola>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 8 Nov 2010 20:36:57 -0500
X-Google-Sender-Auth: rIfQKB3jtrb5FL6XwKDgw79u6gc
Message-ID: <AANLkTimxM=3fg9_nEkfa5SnODEuj29u0k-vzF+LVG+iL@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1362-hcd - fix section mismatch warning
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Lothar Wassmann <LW@karo-electronics.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 20:16, Axel Lin wrote:
> Fix section mismatch warning by using "__devinit" annotation for isp1362_probe.

odd that i hadnt noticed this yet in my randconfig compiles.  looks
perfectly sane to me ... thanks !

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
