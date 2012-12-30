Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab2L3FlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:41:05 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57060 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2L3FlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:41:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
References: <CAHfmSg2akcYUwDW38g520Fwyr17E5dFDpuUMKejQCfLpQ4pnhQ@mail.gmail.com>
	<CAHfmSg3ug=64vXtsA4EA6xdKaqWRtT7qZW9AG8n92Q+pbDgQEQ@mail.gmail.com>
Date: Sun, 30 Dec 2012 13:41:01 +0800
Message-ID: <CAJd=RBCSJ8DbjFEa0Fh92dQowZ5cOdXk0APz8T5ELFmiCvDkqA@mail.gmail.com>
Subject: Re: PROBLEM: Random kernel panic & system freeze when watching video
From: Hillf Danton <dhillf@gmail.com>
To: Du Jiulun <dujiulun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 1:45 AM, Du Jiulun <dujiulun@gmail.com> wrote:
> I'm experiencing random (but frequent) kernel panics and system
> freezes without panic information while I'm watching videos using
> SMPlayer or Google Chrome (with Flash plugin).
>
Is it triggered only when watching video?

> [4.] Kernel version (from /proc/version):
>
> Linux version 3.6.10-1-ck (xiaodu@xiaodupc) (gcc version 4.7.2 (GCC) )
> #1 SMP PREEMPT Wed Dec 12 15:26:26 CST 2012
>
(btw, are you playing BFS?)
Can you please try the latest stable kernel?

Hillf
