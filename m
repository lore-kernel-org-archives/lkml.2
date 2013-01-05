Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3AETvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 14:51:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:53631 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3AETvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 14:51:35 -0500
Message-ID: <50E88491.4060703@infradead.org>
Date: Sat, 05 Jan 2013 11:52:49 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: mmotm 2013-01-04-15-43 uploaded (aio)
References: <20130104234405.8750720004E@hpza10.eem.corp.google.com>
In-Reply-To: <20130104234405.8750720004E@hpza10.eem.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/13 15:44, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2013-01-04-15-43 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 


A few hundred of these warnings:

include/linux/aio.h:102:43: warning: 'return' with a value, in function returning void [enabled by default]

and these errors:

fs/aio.c:697:2: error: dereferencing pointer to incomplete type
fs/aio.c:697:2: error: dereferencing pointer to incomplete type
fs/aio.c:697:2: error: dereferencing pointer to incomplete type
fs/aio.c:707:21: error: dereferencing pointer to incomplete type
fs/aio.c:808:30: error: dereferencing pointer to incomplete type
fs/aio.c:824:40: error: dereferencing pointer to incomplete type
fs/aio.c:826:25: error: storage size of 'batch_stack' isn't known

when CONFIG_BLOCK is not enabled.

-- 
~Randy
