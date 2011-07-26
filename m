Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab1GZJEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:04:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52289 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1GZJEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <91969FDC112D9742BC923801900F5661205D1B431F@EXGMBX01.sasken.com>
References: <91969FDC112D9742BC923801900F5661205D1B431F@EXGMBX01.sasken.com>
Date: Tue, 26 Jul 2011 12:04:48 +0300
Message-ID: <CAMhs6Yx5p=mTg59Wtyv7PzpmizZv0Bm8nQ5X5CW+Vo52Ke-ERA@mail.gmail.com>
Subject: Re: Crash while using completions
From: Maxin B John <maxin.john@gmail.com>
To: Neha Singhal <neha.singhal@sasken.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neha,

On Mon, Jul 25, 2011 at 9:30 AM, Neha Singhal <neha.singhal@sasken.com> wrote:
> Hi,
>
> I am new to kernel programming. I am trying to use completion technique to synchronize two threads. But i am >facing a crash due to NULL pointer reference. does anyone also face crash while using completion or have idea >about it.  Crash seems to be like this:

Care to send some more information related this crash ?   From this
log, I can get the kernel version:2.6.35.7 and can also assume that
you are working on an ARM target. If you can share your code, it will
help us to analyze problem in a better way.

Warm Regards,
Maxin
