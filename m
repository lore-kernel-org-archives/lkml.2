Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2EZNjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:39:49 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60967 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2EZNjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:39:48 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXhyAavikU=861nVA3WjPsMjBt+XOTUJ08VAoinZ1gCRzQ@mail.gmail.com>
References: <CANQmPXhyAavikU=861nVA3WjPsMjBt+XOTUJ08VAoinZ1gCRzQ@mail.gmail.com>
Date: Sat, 26 May 2012 21:39:47 +0800
Message-ID: <CANQmPXgdaiSUV89Vk_xR3dRAyKeGK6x=CJwaSLTC_gv_ocNP1A@mail.gmail.com>
Subject: Re: [ANNOUNCE][PATCH 5/26]Rotary Interactivity Favor Scheduler
 Version 3(Brain-Eating) Update.
From: Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 9:38 PM, Chen <hi3766691@gmail.com> wrote:
> Hi everyone.
> RIFS v3 has been released.
> This version make a big change from RIFS v2(Algorithm).
> Actually it solves problems that V2 left.
> On my box I can play 320K MP3 music without any skipping(SMOOTH!).Also
> I can shake my windows frequently.
>
> 1.latt benchmark
> Parameters: min_wait=100ms, max_wait=500ms, clients=1
> Entries logged: 108
>
> Wakeup averages
> -------------------------------------
>        Max                   25 usec
>        Avg                   10 usec
>        Stdev                  2 usec
>        Stdev mean             0 usec
>
> Work averages
> -------------------------------------
>        Max                21183 usec
>        Avg                20129 usec
>        Stdev                246 usec
>        Stdev mean            24 usec
>
>
> 2.latt benchmark
> Parameters: min_wait=100ms, max_wait=500ms, clients=1
> Entries logged: 108
>
> Wakeup averages
> -------------------------------------
> Max 22 usec
> Avg 8 usec
> Stdev 2 usec
> Stdev mean 0 usec
>
> Work averages
> -------------------------------------
> Max 20326 usec
> Avg 20016 usec
> Stdev 85 usec
> Stdev mean 8 usec
>
> ~~~ :-)
> Enjoy the interactive feels.
> 享受交互性带来的感觉把
>                                                               Chen

Rotating priority for cpu intensive task does not exist anymore. :-)
