Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2G0VpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 17:45:21 -0400
Received: from mail-hostigation.familyross.net ([69.85.93.112]:59988 "EHLO
	mail.familyross.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2G0VpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 17:45:20 -0400
Message-ID: <50130BEE.8080402@familyross.net>
Date: Fri, 27 Jul 2012 14:45:18 -0700
From: Kevin Ross <kevin@familyross.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux RAID <linux-raid@vger.kernel.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RAID extremely slow
References: <501078B2.8070707@familyross.net> <501096C3.5060700@turmel.org> <5010A386.4080209@familyross.net> <5010CEFF.5030606@familyross.net> <5012E717.9070808@tmr.com>
In-Reply-To: <5012E717.9070808@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 12:08 PM, Bill Davidsen wrote:
> Have you set the io scheduler to deadline on all members of the array? 
> That's kind of "job one" on older kernels.
>

I have not, thanks for the tip, I'll look into that now.

Thanks!
-- Kevin

