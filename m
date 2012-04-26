Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab2DZWpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:45:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60138 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab2DZWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <4F99C74D.9050807@fold.natur.cuni.cz>
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
	<CAE9FiQWFAYHTKtv1_MF-SYTrBxUg3zYbfuuxu2uGXHGmEYSf5A@mail.gmail.com>
	<4F99C74D.9050807@fold.natur.cuni.cz>
Date: Thu, 26 Apr 2012 15:44:39 -0700
X-Google-Sender-Auth: UIOycQnwNwDDhGp9Tnvo622lTtQ
Message-ID: <CAE9FiQVmnah5y1-+jAcB-0X424spO8vCNj-EjFTKpi+S=e_Low@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 3:08 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>
>
> Yinghai Lu wrote:
>>
>> Can you try boot the system without loading xhci driver ?
>
> Bingo! Physical express card removal started to be notified correctly.

good, please get lspci -vvxxx -s 00:1c.7
before removing that express card
on both case.

We can compare those two to find out why.

Thanks

Yinghai
