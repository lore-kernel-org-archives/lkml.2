Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0JLL4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:56:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42180 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab0JLL4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:56:46 -0400
Date: Tue, 12 Oct 2010 13:56:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Subject: Re: [PATCH 14(16] pramfs: memory protection
Message-ID: <20101012115639.GB20436@basil.fritz.box>
References: <4CB1EBA2.8090409@gmail.com>
 <87aamm3si1.fsf@basil.nowhere.org>
 <4CB34A1A.3030003@gmail.com>
 <20101012074522.GA20436@basil.fritz.box>
 <AANLkTinpoL+AMU62PMvXs78Y6v0efDm3eq++NiVk8XUB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpoL+AMU62PMvXs78Y6v0efDm3eq++NiVk8XUB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> per-arch?! Wow. Mmm...maybe I have to change something at fs level to
> avoid that. An alternative could be to use the follow_pte solution but
> avoid the protection via Kconfig if the fs is used on some archs (ia64
> or MIPS), with large pages and so on. An help of the kernel community
> to know all these particular cases is welcome.

It depends if the protection is a fundamental part of your design
(but if it is I would argue that's broken because it's really not very good
protection): If it's just an optional nice to have you can stub
it out on architectures that don't support it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
