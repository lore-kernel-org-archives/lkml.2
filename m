Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0HXNM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:12:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab0HXNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:12:57 -0400
Message-ID: <4C73C425.20503@kernel.org>
Date: Tue, 24 Aug 2010 15:07:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue destruction BUG_ON
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>	 <4C739DC6.1040309@kernel.org>	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>	 <4C73BC96.6000003@kernel.org> <1282655414.3695.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282655414.3695.25.camel@jlt3.sipsolutions.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 13:12:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/24/2010 03:10 PM, Johannes Berg wrote:
>> From 492a242b75b0abae3b1c17b4a654ab9ef67e612d Mon Sep 17 00:00:00 2001
>> From: Tejun Heo <tj@kernel.org>
>> Date: Tue, 24 Aug 2010 14:22:47 +0200
>> Subject: [PATCH] workqueue: improve destroy_workqueue() debuggability
> 
> With this patch applied I still get just the BUG_ON:

Hmmm... weird.

> [  500.874185] ------------[ cut here ]------------
> [  500.875212] kernel BUG at kernel/workqueue.c:2849!

Are you sure you're running the patched kernel?  With the patch
applied, the BUG_ON() wouldn't be on line 2849 (on both rc1 and 2).

Thanks.

-- 
tejun
