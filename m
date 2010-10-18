Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab0JRUE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:04:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64925 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0JRUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:04:25 -0400
Message-ID: <4CBCA833.7090104@kernel.org>
Date: Mon, 18 Oct 2010 13:04:03 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest memblock patches
References: <AANLkTimdNFZwao_dCnAq2D=obq_Qccn-M8mNvUeoecc2@mail.gmail.com>
In-Reply-To: <AANLkTimdNFZwao_dCnAq2D=obq_Qccn-M8mNvUeoecc2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 01:02 PM, Felipe Contreras wrote:
> Hi,
> 
> Russell is worried that the latest memblock patches or x86 are going
> to affect ARM negatively. I would like to try them to find out if
> that's the case.
> 
> Do you know if there's a branch available somewhere with the memblock
> patches that will be merged on .37?

please check

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/memblock

Thanks

Yinghai Lu
