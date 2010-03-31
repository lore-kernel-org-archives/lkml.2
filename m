Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0CaQ1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 12:27:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:40303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757754Ab0CaQ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 12:27:06 -0400
Message-ID: <4BB3777F.8030804@kernel.org>
Date: Wed, 31 Mar 2010 09:25:35 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 11:47 PM, James Morris wrote:
> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
> 
>> On 03/30/2010 09:49 PM, James Morris wrote:
>>> Please make NO_BOOTMEM default to n, at least for amd64, where I've found 
>>> that it leads to all kinds of strange, undebuggable boot hangs and errors 
>>> (with relatively current Fedora development userland).
>>
>> Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
> 
> Yes, it was happening with -rc3.

please send out bootlog if possible.

BTW please try
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git

Thanks

Yinghai
