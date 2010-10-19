Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0JSQH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:07:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37468 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab0JSQH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tFDWHFpc9dIzgm5j+rNwhYwrwr13YnU5oou7zB7TI8g2WSEFMh/1+dbqXz8jEtn7z8
         RPtJw06L6AwMwrcXWkMmum9kFId0DPJvltr6lvhsUN2Sxwu+sAzSUu6PkD1soQZhZm93
         KzJnhjXlB/NI32v9uUFGQ7gsMEKljUwxJBMY0=
Message-ID: <4CBDC23C.6050403@lwfinger.net>
Date: Tue, 19 Oct 2010 11:07:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
References: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net> <1287503882.1084.22.camel@i7.infradead.org>
In-Reply-To: <1287503882.1084.22.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 10:58 AM, David Woodhouse wrote:
> On Tue, 2010-10-19 at 10:54 -0500, Larry Finger wrote:
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of version 2 of the GNU General Public License as
>> + * published by the Free Software Foundation. 
> 
> Where is the source code, then?
> 

The source code for the driver with inline firmware is in linux-next in
drivers/staging/rtl8712 and was pushed through GregKH.

Larry

