Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0FKFbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 01:31:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56123 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0FKFbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 01:31:20 -0400
Message-ID: <4C11CA1C.3010102@zytor.com>
Date: Thu, 10 Jun 2010 22:31:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Panic on boot on today's tip/master
References: <20100610112839.GK5878@linux.vnet.ibm.com>
In-Reply-To: <20100610112839.GK5878@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 04:28 AM, Srikar Dronamraju wrote:
> When I updated my tip/master and rebooted into it, I am seeing a panic on boot.
> 
> 
> Here is the ooops message. (x86_64 box)
> 
> 
> previously it booted well with commit
> a2e42da15c9c72bc7caf9e494d409819babbc9c8
> 

Any way you could run a bisect between these commits?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

