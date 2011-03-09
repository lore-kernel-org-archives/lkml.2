Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1CIJEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:04:02 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1852 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909Ab1CIJDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:03:55 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: "gregkh@suse.de" <gregkh@suse.de>,
        "Francis Moreau" <francis.moro@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi
 switch to OFF
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
Date: Wed, 9 Mar 2011 10:03:41 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vr2jgfwg3ri7v4@arend-laptop>
In-Reply-To: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 61699C8C3T84510251-01-01
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
> There's no trace so I don't really know how I can help to debug this  
> further.
>
> Thanks

Hi Greg,

A while ago I submitted a patch for this issue and it was marked as new  
functionality so only to be included in the staging-next branch. However,  
as the system freezes without this patch it might be a good idea to submit  
the patch for staging-linus branch as well to include it in linus tree. Do  
you agree? If so I will prepare a backported version of the patch and send  
it to you.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

