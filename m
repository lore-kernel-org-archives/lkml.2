Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0INF7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 01:59:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47469 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab0INF7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 01:59:50 -0400
Message-ID: <4C8F0F53.10108@monstr.eu>
Date: Tue, 14 Sep 2010 07:59:47 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH next 03/16] arch/microblaze: Use static const char * const
 where possible
References: <cover.1284435709.git.joe@perches.com> <8ed12f6c1a30747223f4c684ae31ce5c8846dd13.1284435709.git.joe@perches.com>
In-Reply-To: <8ed12f6c1a30747223f4c684ae31ce5c8846dd13.1284435709.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/microblaze/kernel/heartbeat.c |   10 +++++-----
>  arch/microblaze/kernel/timer.c     |   12 ++++++------
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 


Applied.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
