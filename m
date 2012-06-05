Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab2FENCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:02:52 -0400
Received: from natasha.panasas.com ([67.152.220.90]:42602 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2FENCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:02:51 -0400
Message-ID: <4FCE0364.9080004@panasas.com>
Date: Tue, 5 Jun 2012 16:02:28 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, <osd-dev@open-osd.org>
Subject: Re: [PATCH] exofs: stop using s_dirt
References: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>  <4FCCDE86.4060507@panasas.com> <1338892543.2507.41.camel@sauron.fi.intel.com>
In-Reply-To: <1338892543.2507.41.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 01:35 PM, Artem Bityutskiy wrote:

> On Mon, 2012-06-04 at 19:12 +0300, Boaz Harrosh wrote:
>> Should I take this for 3.6 through my tree. Or do you want my:
> 
> Forgot to answer this question, sorry: if it is fine with you, please,
> merge it through your tree.
> 


I will. It should appear on linux-next, next time I push new patches
destined for 3.6 Kernel

I conducted some tests and you are absolutely right. There is no effect
it is just dead code.

Thanks again
Boaz
