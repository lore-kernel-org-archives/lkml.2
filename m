Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2CXKAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:00:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50599 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2CXKAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:00:12 -0400
MIME-Version: 1.0
In-Reply-To: <201203240553.32526.gene.heskett@gmail.com>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
	<201203240553.32526.gene.heskett@gmail.com>
Date: Sat, 24 Mar 2012 21:00:10 +1100
X-Google-Sender-Auth: 76berWyrURBevZ7PKgeROH4UGxQ
Message-ID: <CABqErrEMwr-cMPjB=Vv=OwEycPT+nC=4PuMZUasmvWmf9dh_rw@mail.gmail.com>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
From: Con Kolivas <kernel@kolivas.org>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/24 Gene Heskett <gene.heskett@gmail.com>:
> On Saturday, March 24, 2012, Con Kolivas wrote:
>>This is to announce the first stable release of the BFS CPU scheduler
>>for linux 3.3.0 designed for optimal interactivity, responsiveness and
>>throughput on commodity hardware.
>
> URL?

My bad.

This patch is:
http://ck.kolivas.org/patches/bfs/3.3.0/3.3-sched-bfs-420.patch

All BFS patches are here:
http://ck.kolivas.org/patches/bfs/
>
> I for one am happy to see this, Con.  I have been running an earlier patch
> as pclos applies it to 2.6.38.8, and I must say the desktop interactivity
> is very much improved over the non-bfs version.

Thanks for the feedback. Enjoy.

Regards,
Con
