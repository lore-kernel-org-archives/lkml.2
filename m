Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0JTQkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:40:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61134 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab0JTQku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BEAQEq59u5cGO9pHwaspywMJ/bqv5jS5fHb+uHYJU05LRqqq5wPKSiGzerVTJlnUkX
         Dzvn8zF7TF4Pw/bl/BpEcX3lUk7zVVZQiYBkcom2LIsT9/fZDyXwzQsVBh4J5zc3U6YB
         oFzK7o2xWJ6ale3vKtssu9phwOEfNNsAAYkI4=
Message-ID: <4CBF1B00.20105@lwfinger.net>
Date: Wed, 20 Oct 2010 11:38:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
References: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net> <201010191935.40788.arnd@arndb.de> <4CBDE1C1.4020204@lwfinger.net> <201010192229.30133.arnd@arndb.de>
In-Reply-To: <201010192229.30133.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 03:29 PM, Arnd Bergmann wrote:
> On Tuesday 19 October 2010 20:21:53 Larry Finger wrote:
>
> Ok, so if you have the firmware source, add a proper make file and the source along
> with the binary file. You made it sound like the you only had the firmware as
> a hexdump, which would not be possible under the GPLv2 section 3, which says
> "The source code for a work means the preferred form of the work for making
> modifications to it".

Having a patch with the full firmware source and the binary as well seems a bit
large, but I will supply it that way.

>> That Merello copyright really has little to do with the current driver. As
>> Realtek included it in their source, I left it in, but consider it to be an
>> honorary citation.
> 
> That part is fine, what is not fine is the "All rights reserved" portion, which
> contradicts the GPL.

Yes, it is schizophrenic, but I left it the way it was.

Larry
