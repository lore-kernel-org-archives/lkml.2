Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0FQIFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:05:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54863 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab0FQIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:05:01 -0400
To: Richard Yao <shiningarcanine@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does the kernel page the CFS's red-black tree nodes?
From: Andi Kleen <andi@firstfloor.org>
References: <AANLkTilfw_rXQ4P1jRnrOtun2c9kAq6zNEQHxTF124_x@mail.gmail.com>
	<AANLkTilOK580U03orIO6jcMvzrHeNsykLSMkdlw0hZLI@mail.gmail.com>
Date: Thu, 17 Jun 2010 10:04:55 +0200
In-Reply-To: <AANLkTilOK580U03orIO6jcMvzrHeNsykLSMkdlw0hZLI@mail.gmail.com> (Richard Yao's message of "Tue\, 15 Jun 2010 20\:55\:20 -0400")
Message-ID: <87r5k6ulso.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Yao <shiningarcanine@gmail.com> writes:
>
> With that said, does the kernel page the CFS's red-black tree nodes to
> swap? If it does, it might be a good idea to reimplement the CFS'
> Red-Black trees in B-Trees, which would minimize slow-downs from
> vm-pressure and also have the additional benefit of minimizing cache
> misses caused by tree traversal.

The kernel does not swap itself, but yes in theory btrees might help to 
improve CPU cache locality.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
