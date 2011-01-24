Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1AXV0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:26:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61331 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1AXV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PJwZlOcNtSZeJdBiaw5atldFnj9eAmfhdPHkm5QhTU/Si1YXuW3NhalN6Rwkx4ayi6
         3QlkfTASepinfHx1abtaLQKWYLzcGmr0b3isChW0L31AyKd8RVKkLYH/G7jJNHfYd1z4
         MGY73kNgR5mGB7jFiErLLlUaJzxNitIVBiCXo=
MIME-Version: 1.0
In-Reply-To: <1295891761-18366-9-git-send-email-catalin.marinas@arm.com>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	<1295891761-18366-9-git-send-email-catalin.marinas@arm.com>
Date: Tue, 25 Jan 2011 08:26:42 +1100
Message-ID: <AANLkTi=d0q0Upde3=b4tpu3icOr4XdifcFRvBHuXgsBN@mail.gmail.com>
Subject: Re: [PATCH v4 08/19] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Nick Piggin <npiggin@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Too bad about the PAE thing; my condolences.


On Tue, Jan 25, 2011 at 4:55 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch introduces the pgtable-3level*.h files with definitions
> specific to the LPAE page table format (3 levels of page tables).

Seeing as you're shaking up these definitions, what do you think about
switching from 4level-fixup.h to pgtable-nopud.h / pgtable-nopmd.h headers?
One day eventually it would be nice to get rid of the fixup mode.
