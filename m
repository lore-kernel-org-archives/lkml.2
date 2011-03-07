Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1CGH4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:56:40 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2303 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1CGH4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:56:39 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: "Brett Rudley" <brudley@broadcom.com>,
        "Francis Moreau" <francis.moro@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi
 switch to OFF
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
Date: Mon, 7 Mar 2011 08:56:20 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vryqz6qt3ri7v4@arend-laptop>
In-Reply-To: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 616A4FB13T82885636-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Mar 2011 18:11:20 +0100, Francis Moreau  
<francis.moro@gmail.com> wrote:

> Hi,
>
> I'm currently running 2.6.38-rc6, and if I boot with my WIFI switch
> set to off position, the system freezes entirely when bringing up the
> wlan0 interface.
>
Hi Francis,

Some time ago we (broadcom) submitted a patch for rfkill functionality  
(ie. wifi switch) to staging-2.6 repository. I looked up the tagged  
version you are referring to in the linux-next repository and it seems  
that the patch I mentioned is not included in there.

>
> There's no trace so I don't really know how I can help to debug this  
> further.
>
> Thanks

Regards,
Arend van Spriel
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

