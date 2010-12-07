Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0LGLFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:05:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63508 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab0LGLFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:05:43 -0500
MIME-Version: 1.0
X-Originating-IP: [196.200.19.10]
In-Reply-To: <AANLkTi=d8y_zVaHHH6fHqqrJ0-R0inq=2pyk6fXtitEH@mail.gmail.com>
References: <AANLkTi=d8y_zVaHHH6fHqqrJ0-R0inq=2pyk6fXtitEH@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Tue, 7 Dec 2010 14:05:21 +0300
Message-ID: <AANLkTim_w0jCAj5Fua-qea+Zd_3LwanHLLa+suU18XX1@mail.gmail.com>
Subject: Re: [kdump core available] Kernel Panic in 2.6.36.1
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 7:29 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
> Hello,
>
> Following is a bug report on a Kernel Panic in 2.6.36.1.
>
> I have been experiencing (what I think) is the same panic since I
> installed 2.6.36.1, but I have never been able to get any stack trace.
> Finally, I was able to get a proper trace after configuring
> kexec/kdump.
>
> It is true that my kernel is tainted by a proprietary nvidia module,
> but I am hoping the fact that I have a level 7 makedumpfile(8) core
> available and that I am willing to readily furnish any information
> asked for through the crash(8) utility will make up for this.
>
> I do not want to be misleading but the panic seems to happen when I am
> using my Huawei 3G USB modem, and have just been connected for some
> reason or other. But I may be wrong.
>
> Below is the information from crash(8). (I will be happy to answer any
> further questions). Thanks
>

Hello,

Does anyone need any further information on this or should I try and
replicate this without the taint?

Thanks.

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
