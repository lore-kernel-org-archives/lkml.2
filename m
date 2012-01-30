Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2A3X6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:58:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab2A3X6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:58:04 -0500
Date: Mon, 30 Jan 2012 21:57:52 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: remove .. in perf includes/
Message-ID: <20120130235752.GE5797@infradead.org>
References: <1327091804-3984-1-git-send-email-andi@firstfloor.org> <20120130191429.GB5797@infradead.org> <4F270F67.4070809@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F270F67.4070809@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 30, 2012 at 01:45:11PM -0800, Andi Kleen escreveu:
> On 1/30/2012 11:14 AM, Arnaldo Carvalho de Melo wrote:
>> Em Fri, Jan 20, 2012 at 12:36:44PM -0800, Andi Kleen escreveu:
>>> From: Andi Kleen<ak@linux.intel.com>
>>> - Add all the relevant directories as -I in the Makefile
>>> - Remove (near) all the .. in include statements
>>> - Remove unnecessary wrappers that do nothing
>>> - Fix up some fallout
>>>
>>> This makes the code more pleasant to read.
>>>
>>> I did it all in one big patch to keep bisectability.
>> It builds, but breaks this:
>
> Hmm cannot reproduce. The extra tarball builds fine and includes memset_64.S
> with my patch on Linus latest.

Humm, there was a patch for 'perf bench' that came after your patch and
I applied before yours, I bet that is the problem, I'll get that
checked.

Thanks,

- Arnaldo
