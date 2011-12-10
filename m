Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1LJVzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 16:55:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32841 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1LJVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 16:55:04 -0500
MIME-Version: 1.0
In-Reply-To: <1323512662.1816.115.camel@epip-laptop>
References: <20111209211346.GA2639@outflux.net>
	<1323512662.1816.115.camel@epip-laptop>
Date: Sat, 10 Dec 2011 13:55:03 -0800
X-Google-Sender-Auth: a3xstixMbQkHUXKe9qO04n3ZHSk
Message-ID: <CAGXu5jLvS1taC2ofGLmRh5kxF25Djaonf3T-xMF+-VBL+WWx-Q@mail.gmail.com>
Subject: Re: [PATCH] unicore32: standardize /proc/iomem "Kernel code" name
From: Kees Cook <keescook@chromium.org>
To: gxt@mprc.pku.edu.cn
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 2:24 AM, Guan Xuetao <gxt@mprc.pku.edu.cn> wrote:
> On Fri, 2011-12-09 at 13:13 -0800, Kees Cook wrote:
>> All other ports use "Kernel code" to identify the Kernel text segment
>> in /proc/iomem. Change the ARM resources to do the same.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Thanks Cook.
>
> Our architecture/ISA is unicore32, not arm.

Hah, oops, sorry. I reused the commit message I sent for a similar
change in ARM. :)


-- 
Kees Cook
ChromeOS Security
