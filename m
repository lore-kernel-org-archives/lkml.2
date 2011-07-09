Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1GIAp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 20:45:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937Ab1GIAp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 20:45:57 -0400
Message-ID: <4E17A4BF.5050500@redhat.com>
Date: Fri, 08 Jul 2011 20:45:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.0-rc6 ~9X system time degradation on kernbench
References: <4E175C45.1060700@redhat.com>
In-Reply-To: <4E175C45.1060700@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2011 03:36 PM, Prarit Bhargava wrote:
> Just some numbers out of kernbench.  System Time&  Context Switches
> climb dramatically between 2.6.38 and 3.0.0-rc6.  Currently bisecting to
> find out why.  .config is based on Fedora's x86_64 .config.

For the record, I am also seeing dramatically increased
CPU use with the 3.0-rc kernel, vs 2.6.38.

I first attributed it to me upgrading my video card, but
Prarit is seeing slowdowns too, so it's not just me...

-- 
All rights reversed
