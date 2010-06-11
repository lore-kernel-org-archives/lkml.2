Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab0FKKGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:06:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48316 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841Ab0FKKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:06:45 -0400
Subject: Re: [PATCH -mm] only drop root anon_vma if not self
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <AANLkTiktcGrj-tcMspzR3sXplKk-PFB7M4q7rb-WiwYP@mail.gmail.com>
References: <AANLkTiktcGrj-tcMspzR3sXplKk-PFB7M4q7rb-WiwYP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 11 Jun 2010 11:06:12 +0100
Message-ID: <1276250772.12258.57.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2010 10:06:13.0447 (UTC) FILETIME=[B9334D70:01CB094D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 10:48 +0100, Dave Young wrote:
> I got an oops when shutdown kvm guest with rik's patch applied, but
> without your bootmem patch, is it kmemleak problem?

It could be, though I've never got it before.

Can you run this on your vmlinux file?

addr2line -i -f -e vmlinux c10c5c88

Thanks.

-- 
Catalin

