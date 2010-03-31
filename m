Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0CaMHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:07:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38142 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756535Ab0CaMG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:06:59 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sachin Pandhare <sachinpandhare@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemleak_scan_area
References: <n2m72cf309c1003310300k26b9aacbob7b49ff2f43f949d@mail.gmail.com>
Date: Wed, 31 Mar 2010 13:06:49 +0100
In-Reply-To: <n2m72cf309c1003310300k26b9aacbob7b49ff2f43f949d@mail.gmail.com>
	(Sachin Pandhare's message of "Wed, 31 Mar 2010 15:30:11 +0530")
Message-ID: <tnx7hosy9t2.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Mar 2010 12:06:54.0494 (UTC) FILETIME=[A77563E0:01CAD0CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Pandhare <sachinpandhare@gmail.com> wrote:
> In kmemleak.c file "kmemleak_scan_area" is appearing as a structure as
> well as a function.
> e.g.:
> - struct kmemleak_scan_area {
> - void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
>
> Do you think it is a good to have it like that?

Does it cause any problems? I think C has different namespaces for types
and functions, so they should not collide. I agree that from a
readability perspective, it would be better if they are named
differently (like kmemleak_scan_area_node :)).

-- 
Catalin
