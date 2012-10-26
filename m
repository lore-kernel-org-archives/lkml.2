Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966799Ab2JZWbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 18:31:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57281 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966776Ab2JZWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 18:31:41 -0400
Message-ID: <508B0F4B.80601@gmail.com>
Date: Fri, 26 Oct 2012 15:31:39 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: shuah.khan@hp.com
CC: ralf@linux-mips.org, kyungmin.park@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, m.szyprowski@samsung.com,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH RFT RESEND linux-next] mips: dma-mapping: support debug_dma_mapping_error
References: <1351208193.6851.17.camel@lorien2>  <1351267298.4013.12.camel@lorien2> <508ABE1D.5010106@gmail.com>  <1351271198.4013.35.camel@lorien2> <508AED66.3040808@gmail.com> <1351288264.6885.11.camel@lorien2>
In-Reply-To: <1351288264.6885.11.camel@lorien2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 02:51 PM, Shuah Khan wrote:

>>>> On 10/26/2012 09:01 AM, Shuah Khan wrote:
>>>>> Add support for debug_dma_mapping_error() call to avoid warning from
>>>>> debug_dma_unmap() interface when it checks for mapping error checked
>>>>> status. Without this patch, device driver failed to check map error
>>>>> warning is generated.

I'm confused.

Your claim that a 'warning is generated' seems to be in conflict with...


[...]
> Got it. Thanks. I would volunteer to look at fixing all the problems,
> but unfortunately I don't have a MIPS box handy

This statement that you don't have hardware that exhibits the problem.

How was the patch tested?  How do you even know there is a problem?

David Daney


