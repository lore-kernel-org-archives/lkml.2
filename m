Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab0KDKM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:12:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:60468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0KDKM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:12:26 -0400
Message-ID: <4CD286E4.8070802@kernel.org>
Date: Thu, 04 Nov 2010 11:11:48 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Marcus Meissner <meissner@suse.de>
CC: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, mort@sgi.com, akpm@osdl.org, security@kernel.org
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101104100914.GC25118@suse.de>
In-Reply-To: <20101104100914.GC25118@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Nov 2010 10:11:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 11:09 AM, Marcus Meissner wrote:
> Making /proc/kallsyms readable only for root makes it harder
> for attackers to write generic kernel exploits by removing
> one source of knowledge where things are in the kernel.
> 
> Signed-off-by: Marcus Meissner <meissner@suse.de>

I can't recall needing /proc/kallsyms when I wasn't root, so unless
there's a compelling use case.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
