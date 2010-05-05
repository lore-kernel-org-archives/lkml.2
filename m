Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab0EEJ5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:57:52 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:58138 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab0EEJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:57:51 -0400
Message-ID: <4BE140F3.3070901@ru.mvista.com>
Date: Wed, 05 May 2010 13:57:07 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
CC: paulius.zaleckas@gmail.com, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Gemini: fix compiler error in copypage-fa.c
References: <1272983655-18408-1-git-send-email-ulli.kroll@googlemail.com>
In-Reply-To: <1272983655-18408-1-git-send-email-ulli.kroll@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hans Ulli Kroll wrote:

> Fix compiler error in copypage-fs.c
>   

   You've called it copypage-fa.c in the subject.

> missing struct vm_area_struct *vma in function
> fa_copy_user_highpage
>
> Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> ---
>  arch/arm/mm/copypage-fa.c |    2 +-
>   

   And the file name is indeed copypage-fa.c...

WBR, Sergei

