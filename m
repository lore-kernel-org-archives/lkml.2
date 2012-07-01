Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2GAUwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:52:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab2GAUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:52:50 -0400
Message-ID: <4FF0B891.8080804@zytor.com>
Date: Sun, 01 Jul 2012 13:52:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Tejun Heo <tj@kernel.org>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com> <4FCAD590.8000506@zytor.com> <87obp0bxdv.fsf@xmission.com> <4FCB602B.70907@zytor.com> <87fwacb0jq.fsf_-_@xmission.com> <877gvob0g4.fsf_-_@xmission.com> <4FF06701.6010004@zytor.com> <4FF06DF4.4000006@zytor.com> <87wr2nsbvi.fsf@xmission.com> <4FF0769F.8090105@zytor.com> <87sjdbsb0v.fsf@xmission.com> <4FF07E66.2020706@zytor.com> <87d34fs914.fsf@xmission.com> <4FF085B1.6070604@zytor.com> <87a9zj9w43.fsf@xmission.com> <4FF098E2.3040307@zytor.com> <87sjdb8f0m.fsf@xmission.com> <4FF0A399.8070207@zytor.com> <87txxr6wre.fsf@xmission.com>
In-Reply-To: <87txxr6wre.fsf@xmission.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 01:40 PM, Eric W. Biederman wrote:
> 
> So I have tracked down part of the crazyness.
> CONFIG_RODATA actually uses 2MB alignment, making
> -z max_page_size=4096 a bit questionable.
> 

Questionable how?  It's not really like it matters since we're not going
to mmap the ELF.

	-hpa
