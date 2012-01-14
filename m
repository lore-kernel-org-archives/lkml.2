Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab2ANV4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:56:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757117Ab2ANV4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:56:11 -0500
Message-ID: <4F11F9FE.7070400@suse.cz>
Date: Sat, 14 Jan 2012 22:56:14 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Julia Lawall <julia@diku.dk>,
        kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle: improve the coverage of some semantic
 patches
References: <1326562543-8448-1-git-send-email-Julia.Lawall@lip6.fr>  <1326577096.2172.2.camel@koala> <1326577949.2172.5.camel@koala>
In-Reply-To: <1326577949.2172.5.camel@koala>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.1.2012 22:52, Artem Bityutskiy wrote:
> On Sat, 2012-01-14 at 23:38 +0200, Artem Bityutskiy wrote:
>> On Sat, 2012-01-14 at 18:35 +0100, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> This patch ensures that all semantic patches in the scripts/coccinelle
>>> directory provide the report option.  Report messages that include line
>>> numbers now have the line number preceded by "line" for easier subsequent
>>> processing.
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Julia, thanks a lot for this harmonization effort!
>>
>> I did not do detailed review, but looks good.
>>
>> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Adding Michal to "To:", since you apparently merge via his tree. Michal,
> would you please pick this one as well?

Yes. My .procmail catched this thread, but thanks for adding me
nevertheless :-).

Michal
