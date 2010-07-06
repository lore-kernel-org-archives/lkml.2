Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0GFAVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:21:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54899 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0GFASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QpBAwC7gni2iiKZl1X+YubXpe95ZFNNe42ejJlqnMV9/0Deiz0MUnQIokx8PT9zlPf
         21LeB4V6RQzNaeXil0J8BDXkCSu4GrCVGtH2JbR8e6JEjm3ufMYodP6XsSVVnoW5wxCI
         EFy25gXk2dIrFaPLwcjjNoKylTJ0brrMqzl/I=
Message-ID: <4C32766C.4080305@gmail.com>
Date: Mon, 05 Jul 2010 18:18:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Priit Laes <plaes@plaes.org>
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: iwl3945: HARDWARE GONE??
References: <1278086575.2889.8.camel@chi>
In-Reply-To: <1278086575.2889.8.camel@chi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 10:02 AM, Priit Laes wrote:
> Heya!
>
> Bumped my kernel to version 2.6.35-rc3-00391-g97e0214 and ran into
> HARDWARE GONE error message..
>
> Hardware is Lenovo x60s and wireless card is intel 3945:
>
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)
> 	Subsystem: Intel Corporation ThinkPad R60e/X60s
> 	Flags: bus master, fast devsel, latency 0, IRQ 47
> 	Memory at edf00000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [c8] Power Management version 2
> 	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> 	Capabilities: [e0] Express Legacy Endpoint, MSI 00
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [140] Device Serial Number 00-xx-xx-xx-xx-xx-xx-xx
> 	Kernel driver in use: iwl3945
> 	Kernel modules: iwl3945

Wonder if somehow an ACPI power resource powering the wireless card got 
switched off? What previous kernel version was working, can you try 
bisecting?
