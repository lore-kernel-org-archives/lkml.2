Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1AQIIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:08:18 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:23731 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab1AQIIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:08:17 -0500
Message-ID: <4D33F8E7.5030900@bfs.de>
Date: Mon, 17 Jan 2011 09:08:07 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] [SCSI] target: dubious one-bit signed bitfield
References: <20110115140445.GD2721@bicker> <4D31CCFB.1060504@bfs.de> <20110115165401.GE2721@bicker>
In-Reply-To: <20110115165401.GE2721@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 15.01.2011 17:54, schrieb Dan Carpenter:
> On Sat, Jan 15, 2011 at 05:36:11PM +0100, walter harms wrote:
>>
>>
>> Am 15.01.2011 15:04, schrieb Dan Carpenter:
>>> The signed one-bit types can be 0 or -1 which can cause a problem if
>>> someone ever checks if (foo->lu_gp_assoc == 1).  The current code is
>>> fine because everyone just checks zero vs non-zero.  But Sparse
>>> complains about it so lets change it.  The warnings look like this:
>>>
>>
>> Your code looks ok,
>> but to avoid that kind of errors it may be better to use int here.
>>
> 
> I'm afraid I don't understand what you are saying.
> 

IMHO, it is better to just drop the bitfield. Most people expect int as return.

re,
 wh
