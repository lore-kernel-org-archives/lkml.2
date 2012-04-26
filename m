Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2DZQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:08:56 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55172 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2DZQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <4F9711AA.1090803@fold.natur.cuni.cz>
References: <4F909CEB.3060407@fold.natur.cuni.cz>
	<CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
	<CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
	<4F91473A.1080007@fold.natur.cuni.cz>
	<CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
	<4F919C22.1070608@fold.natur.cuni.cz>
	<4F919CD5.7070004@fold.natur.cuni.cz>
	<CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com>
	<20120420231748.GB7069@xanatos>
	<CAE9FiQX7JCZvL9S8ZOQQaHQ4nfU0XDj=8FmOfCtcz7WFjP8=Bg@mail.gmail.com>
	<20120421132516.GC7069@xanatos>
	<CAE9FiQUuHrsNPhPWAc9koOrW6Xc+ryOhf_nv2ZyWvG9XMAdNoA@mail.gmail.com>
	<4F9711AA.1090803@fold.natur.cuni.cz>
Date: Thu, 26 Apr 2012 09:08:52 -0700
X-Google-Sender-Auth: 44nxVTBPyjrCbaQnRv98hQW8jns
Message-ID: <CAE9FiQWFAYHTKtv1_MF-SYTrBxUg3zYbfuuxu2uGXHGmEYSf5A@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 1:48 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> (sorry for the re-send, now with the attached dmesg)
>
>
> With the express card itself (no USB devices attached to it) I do not see
> a difference. Is this what you wanted me to test?
>

so disabling autosuspend make no difference.

Can you try boot the system without loading xhci driver ?

Yinghai
