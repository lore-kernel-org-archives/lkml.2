Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2J1VM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 17:12:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58709 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2J1VMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 17:12:55 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 3.7-rc2 kernel BUG at kernel/power/snapshot.c:517!
Date: Sun, 28 Oct 2012 22:12:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.1; KDE/4.8.4; x86_64; ; )
Cc: lenb@kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org, pavel@ucw.cz,
        linux-pm@vger.kernel.org
References: <201210211712.28571.maciej.rutecki@gmail.com>
In-Reply-To: <201210211712.28571.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210282212.50282.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 21 października 2012 o 17:12:28 Maciej Rutecki wrote:
> Error: kernel BUG at kernel/power/snapshot.c:517!
> 
> Last known good: 3.6.1
> Bad: 3.7-rc2
> 
> Steps to reproduce:
> 1. Boot system with 3.7-rc2 kernel
> 2. Try suspend to disk (s2ram works OK)
> 
> System dies on message:
> http://mrutecki.pl/download/kernel/3.7-rc2/swinka/DSCN0280.jpg
> 
> lspci:
> http://mrutecki.pl/download/kernel/3.7-rc2/swinka/lspci.txt
> 
> dmesg:
> http://mrutecki.pl/download/kernel/3.7-rc2/swinka/dmesg-3.7-rc2.txt

Still present in -rc3

Regards

-- 
Maciej Rutecki
http://www.mrutecki.pl
