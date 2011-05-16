Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1EPIT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:19:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:41567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1EPIT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:19:57 -0400
Message-ID: <4DD0DE2C.4060806@suse.cz>
Date: Mon, 16 May 2011 10:19:56 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: mfmooney@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] package: Makefile: fix perf target bug
References: <4DCD8CE4.4090404@suse.cz> <b07e7ecdce48bc90a2cf83e8867494dae7cd174f.1305329845.git.mfm@muteddisk.com> <20110515154002.GB6274@ghostprotocols.net>
In-Reply-To: <20110515154002.GB6274@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.5.2011 17:40, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 13, 2011 at 04:41:12PM -0700, mfmooney@gmail.com escreveu:
>> From: matt mooney<mfm@muteddisk.com>
>>
>> Specify --git-dir when building perf targets to allow out-of-tree
>> builds using O=<build-dir>.
>>
>> The shell command in `git archive' had to be modified to allow proper
>> file name expansion of the files listed in MANIFEST.
>>
>> Signed-off-by: matt mooney<mfm@muteddisk.com>
>
> Michal,
>
> 	Can I have your Reviewed-by or Acked-by for this one? Assuming
> all is ok by now :)

Reviewed-by: Michal Marek <mmarek@suse.cz>

Michal
