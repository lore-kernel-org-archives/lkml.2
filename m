Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2GARPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 13:15:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43813 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2GARPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:15:32 -0400
Message-ID: <4FF085B1.6070604@zytor.com>
Date: Sun, 01 Jul 2012 10:15:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com> <4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com> <4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com> <877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com> <4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com> <4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com> <4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com>
In-Reply-To: <87d34fs914.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 10:09 AM, Eric W. Biederman wrote:
>
> I am suspecting something similar.  At the moment I am trying
> to remember how to get early printk working in misc.c so I can
> poke around a bit more.
>
> The theory that I was working on, that used to be true, and
> seems to be true of everything except the percpu section is
> that objcopy just does the right thing when creating vmlinux.bin.
> vmlinux.bin being what we compress.
>
> I don't see anything obviously wrong with the headers of vmlinux.bin
> although we still unnecessarily have section headers in that file.
>

We leave the section headers in for the benefit of Xen IIRC.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



