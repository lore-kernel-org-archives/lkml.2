Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1FXNWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:22:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34693 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab1FXNWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:22:17 -0400
Message-ID: <4E048F87.7010109@suse.cz>
Date: Fri, 24 Jun 2011 15:22:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: matt mooney <mfmooney@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] package: Makefile: fix perf target bug
References: <4DCD8CE4.4090404@suse.cz>	<b07e7ecdce48bc90a2cf83e8867494dae7cd174f.1305329845.git.mfm@muteddisk.com>	<20110515154002.GB6274@ghostprotocols.net>	<4DD0DE2C.4060806@suse.cz> <BANLkTikvuRwWwb3aux25Ut6ycr0VefrHFQ@mail.gmail.com>
In-Reply-To: <BANLkTikvuRwWwb3aux25Ut6ycr0VefrHFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.6.2011 20:19, matt mooney wrote:
> On Mon, May 16, 2011 at 1:19 AM, Michal Marek<mmarek@suse.cz>  wrote:
>> On 15.5.2011 17:40, Arnaldo Carvalho de Melo wrote:
>>>
>>> Em Fri, May 13, 2011 at 04:41:12PM -0700, mfmooney@gmail.com escreveu:
>>>>
>>>> From: matt mooney<mfm@muteddisk.com>
>>>>
>>>> Specify --git-dir when building perf targets to allow out-of-tree
>>>> builds using O=<build-dir>.
>>>>
>>>> The shell command in `git archive' had to be modified to allow proper
>>>> file name expansion of the files listed in MANIFEST.
>>>>
>>>> Signed-off-by: matt mooney<mfm@muteddisk.com>
>>>
>>> Michal,
>>>
>>>         Can I have your Reviewed-by or Acked-by for this one? Assuming
>>> all is ok by now :)
>>
>> Reviewed-by: Michal Marek<mmarek@suse.cz>
>
> I do not believe this patch ever got picked up!

I thought that Arnaldo will take it. I pushed it to 
kbuild-2.6.git#packaging now.

Michal
