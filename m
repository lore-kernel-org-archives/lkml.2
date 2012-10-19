Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab2JSOHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452Ab2JSOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:07:51 -0400
Message-ID: <50815EA5.5080502@redhat.com>
Date: Fri, 19 Oct 2012 10:07:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/2] rename NUMA fault handling functions
References: <20121018171821.7f1b1683@cuia.bos.redhat.com>  <20121018172021.0b1f6e3d@cuia.bos.redhat.com> <1350646863.30157.13.camel@twins>
In-Reply-To: <1350646863.30157.13.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 07:41 AM, Peter Zijlstra wrote:
> On Thu, 2012-10-18 at 17:20 -0400, Rik van Riel wrote:
>> Having the function name indicate what the function is used
>> for makes the code a little easier to read.  Furthermore,
>> the fault handling code largely consists of do_...._page
>> functions.
>
> I don't much care either way, but I was thinking walken might want to
> use something similar to do WSS estimation, in which case the NUMA name
> is just as wrong.

That's a good point. I had not considered other uses of the
same code.

-- 
All rights reversed
