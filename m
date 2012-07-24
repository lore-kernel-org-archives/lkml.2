Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2GXUvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 16:51:37 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:59419 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab2GXUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 16:51:36 -0400
Date: Tue, 24 Jul 2012 14:51:35 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [GIT PULL 00/15] arm-soc: changes for v3.6
In-Reply-To: <201207240751.39111.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1207241436570.10781@utopia.booyaka.com>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de> <CA+55aFyObNFgsaVOsjVOcH+aLjDyOgcqpvckM29T3dvugekVwg@mail.gmail.com> <201207240751.39111.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, 24 Jul 2012, Arnd Bergmann wrote:

> On Tuesday 24 July 2012, Linus Torvalds wrote:
> 
> > In your "for-linus" branch, "&mpu_3xxx_clkdm" remains in the
> > clockdomains_common[] array. In my merge, it is gone. But I think I
> > did the merge correctly, and you did it wrong. HOWEVER, I don't know
> > the code, maybe there is some subtle reason why you did it like you
> > did.
> 
> Yes, I think you are right now that I look at it again. Paul Walmsley
> can have another look at the merge and send an update if we are both
> missing something now.

Linus' merge is correct.

thanks for asking,

- Paul
