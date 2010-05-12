Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0EMAA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:00:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51948 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0EMAAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:00:25 -0400
Message-ID: <4BEB3F67.4050608@zytor.com>
Date: Wed, 12 May 2010 16:53:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, Peter Jones <pjones@redhat.com>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       gpxe-devel@etherboot.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] ibft: Use IBFT_SIGN instead of open-coding the search
 string.
References: <4BEAB683.8040600@redhat.com>	<1273674308-9366-1-git-send-email-pjones@redhat.com>	<201005121035.33199.konrad@kernel.org> <20100512123323.2badc5a7.akpm@linux-foundation.org>
In-Reply-To: <20100512123323.2badc5a7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 12:33 PM, Andrew Morton wrote:
> On Wed, 12 May 2010 10:35:32 -0400
> Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> 
>> Please also consider this patch with the others I've sent.
>> I've put this (and the other ones) on:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft-2.6.git dev.ibft
> 
> Well, you're the maintainer and you have a git tree and I cannot tell
> the difference between an IBFT and a bar of soap.  So I suggest that
> you ask Stephen to permanently include your git tree in linux-next and
> send Linus a pull request in the 2.6.35-rc1 merge window like so many
> other people do?
> 

Either that or send it via Len Brown, since iBFT really is an ACPI
extension.

	-hpa
