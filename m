Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2DXRVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab2DXRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:21:13 -0400
Message-ID: <4F96E102.9000904@redhat.com>
Date: Tue, 24 Apr 2012 13:21:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Motohiro Kosaki <mkosaki@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm V2] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
References: <4F96CDE1.5000909@redhat.com> <4F96D27A.2050005@gmail.com> <4F96DFE0.6040306@redhat.com>
In-Reply-To: <4F96DFE0.6040306@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 01:16 PM, Larry Woodman wrote:
> On 04/24/2012 12:19 PM, KOSAKI Motohiro wrote:

>> Please use
>>
>> /*
>> * foo bar
>> */
>>
>> style comment. and this comment only explain how code work but don't
>> explain why.
>> I hope the comment describe HPC usecase require to migrate if src and
>> dest have the
>> same weight.

> How does this look:

Still does not explain the "why"...

-- 
All rights reversed
