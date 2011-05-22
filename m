Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1EVHmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 03:42:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34518 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1EVHmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 03:42:36 -0400
Message-ID: <f21331d6ac687d28aa7f9b7f0f5b7620.squirrel@www.firstfloor.org>
In-Reply-To: <alpine.DEB.2.00.1105220816480.12897@skynet.skynet.ie>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
    <alpine.DEB.2.00.1105220816480.12897@skynet.skynet.ie>
Date: Sun, 22 May 2011 09:42:33 +0200
Subject: Re: [PATCH 01/12] Force always inline for gcc 4.5 when optimizing
 for size
From: "Andi Kleen" <andi@firstfloor.org>
To: "Dave Airlie" <airlied@linux.ie>
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, "Andi Kleen" <ak@linux.intel.com>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Oh these look like a good plan, one of our contributors has an inline
> fetish and it got cut-n-pasted into a few places particular in radeon.
>
> But we won't be turning DRM debugging off, its what we use to debug things
> in the field, I did get a patch recently to reduce some of its overhead

Why can't it be a CONFIG option like all other debugging code?

If you want to keep it on would need to drop even more inlines to get
the 50k overhead down.

-Andi

