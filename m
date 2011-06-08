Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab1FHNNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:13:39 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:53278 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab1FHNNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:13:38 -0400
Message-ID: <ae2bdc3089ce0adec73f3d9c52dac609.squirrel@webmail.sf-mail.de>
In-Reply-To: <BANLkTi=LcCiy=wroAuDdcfe3QnfXxke0ww@mail.gmail.com>
References: <20110602142242.GA4115@maxin>
    <BANLkTimYw-WAK3Hd21XQWrjBn_1+wRMzUQ@mail.gmail.com>
    <3838457.LEWxWdrTRM@donald.sf-tec.de>
    <BANLkTi=LcCiy=wroAuDdcfe3QnfXxke0ww@mail.gmail.com>
Date: Wed, 8 Jun 2011 15:13:36 +0200
Subject: Re: [PATCH] mm: dmapool: fix possible use after free in
 dmam_pool_destroy()
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Maxin B John" <maxin.john@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dima@android.com, willy@linux.intel.com,
        segooon@gmail.com, tj@kernel.org, jkosina@suse.cz, tglx@linutronix.de
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
>
> On Tue, Jun 7, 2011 at 7:05 PM, Rolf Eike Beer <eike-kernel@sf-tec.de>
> wrote:
>> Maxin B John wrote:
>>
>>> Could you please let me know your thoughts on this patch ?
>>
>> Makes absolute sense to me.
>>
>> Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
>
> Thanks a lot for reviewing the patch. Should I merge these two patches
> and re-send it as a single one ?

I would do so.

Eike
