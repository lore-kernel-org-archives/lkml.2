Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1CYHup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 03:50:45 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45175 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab1CYHuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 03:50:44 -0400
Message-ID: <4D8C4953.8020808@kernel.dk>
Date: Fri, 25 Mar 2011 08:50:43 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Q] PGPGIN underflow?
References: <20110324105307.1AF3.A69D9226@jp.fujitsu.com> <20110324095735.61bfa370.randy.dunlap@oracle.com>
In-Reply-To: <20110324095735.61bfa370.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-24 17:57, Randy Dunlap wrote:
> On Thu, 24 Mar 2011 10:52:54 +0900 (JST) KOSAKI Motohiro wrote:
> 
>> Hi all,
>>
>> Recently, vmstast show crazy big "bi" value even though the system has
>> no stress. Is this known issue?
>>
>> Thanks.
> 
> underflow?  also looks like -3 or -ESRCH.
> 
> Adding Jens in case he has any idea about it.

First question, what does 'recently' mean? In other words, in what
kernel did you first notice this behaviour?

-- 
Jens Axboe

