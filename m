Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0JLILI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:11:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53461 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab0JLILF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:11:05 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        akpm@linux-foundation.org
Subject: Re: RFC: Implement hwpoison on free for soft offlining
References: <1286402951-1881-1-git-send-email-andi@firstfloor.org>
Date: Tue, 12 Oct 2010 10:11:04 +0200
In-Reply-To: <1286402951-1881-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Thu, 7 Oct 2010 00:09:10 +0200")
Message-ID: <87aamj3k6f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Here's a somewhat experimental patch to improve soft offlining
> in hwpoison, but allowing hwpoison on free for not directly
> freeable page types. It should work for nearly all
> left over page types that get eventually freed, so this makes
> soft offlining nearly universal. The only non handleable page
> types are now pages that never get freed.
>
> Drawback: It needs an additional page flag. Cannot set hwpoison
> directly because that would not be "soft" and cause errors.

Ping? Any comments on this patch?

Except for the page flag use I think it's nearly a no brainer. 
A lot of new soft hwpoison capability for very little additional code.

Has anyone a problem using up a 64bit page flag for that?

Thanks,

-Andi 
-- 
ak@linux.intel.com -- Speaking for myself only.
