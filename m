Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2C0Kpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:45:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2C0Kp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <4F718007.4000401@jp.fujitsu.com>
References: <4F718007.4000401@jp.fujitsu.com>
Date: Tue, 27 Mar 2012 13:45:28 +0300
Message-ID: <CACVxJT_uEZK5-n+bSbjrYo-Fs6zyB_YYpB_apuRjsd=Fno4eHA@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/2] binary stream format for /proc/stat
From: Alexey Dobriyan <adobriyan@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ulrich Drepper <drepper@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/27 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Provides another format of /proc/stat for showing data in binary and
> compress sequence of Zeros to some extent.
>
> Any other idea of formats ?

It mixes everything into one pile.

> From dea9521e84701631e718884d40b5c96cdcd62d7d Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Tue, 27 Mar 2012 13:40:54 +0900
> Subject: [PATCH 1/2] proc: seq_file add binary stream support
>
> /proc/stat shows all data in ascii format and it's easily readable.
> But considering a program which reads /proc/stat periodically, translations
> of ascii <-> binary happens a few times.
>
>  1. binrary -> ascii at showing seq_file
>  2. ascii -> binary for handling in the program.
