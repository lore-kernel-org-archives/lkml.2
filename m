Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab2K3KVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:21:47 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:61908 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab2K3KVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:21:35 -0500
Message-ID: <50B8886B.8030402@cs.tu-berlin.de>
Date: Fri, 30 Nov 2012 11:20:27 +0100
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120324 Thunderbird/10.0.3
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 00/23] printk: refactoring
References: <cover.1351135988.git.joe@perches.com> <1351864140.3537.1.camel@joe-AO722> <1352760850.18715.8.camel@joe-AO722> <20121112152621.eb14d7f0.akpm@linux-foundation.org> <1354226895.1700.12.camel@joe-AO722> <20121129142143.22886573.akpm@linux-foundation.org> <1354229172.1700.18.camel@joe-AO722> <CAPXgP10xdSBT=2onSxwK7tFFJeo0eAtp0ugPWH_tUbxBhFtVHg@mail.gmail.com>
In-Reply-To: <CAPXgP10xdSBT=2onSxwK7tFFJeo0eAtp0ugPWH_tUbxBhFtVHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.11.2012 23:53, schrieb Kay Sievers:
> On Thu, Nov 29, 2012 at 11:46 PM, Joe Perches <joe@perches.com> wrote:
> 
>> It's still a scheduling issue with Kay and Jan's patches.
>> Does anyone have any idea if/when those patches are going in?
> 
> I was expecting that Jan rebases the patches incorporating
> the latest fix. Jan?

This weekend, hopefully, I have time to finish this.

I found one or two other bugs in my code in the meantime, so the
delay has also some positive effects. :)

Regards
Jan
