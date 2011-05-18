Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab1ERPuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:50:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44257 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab1ERPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:50:20 -0400
Date: Wed, 18 May 2011 17:50:17 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
Message-ID: <20110518155017.GA14324@gere.osrc.amd.com>
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1305636919-31165-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Ingo just confirmed that the following two fixes went upstream. I
haven't tagged them for stable so I'd appreciate if you could take them
for the next cycle. AFAICT, the relevant trees should be .38-stable,
32-longterm and 33-longterm.

There should be no problem cherry-picking them but if there is, please
let me know and I'll give you rebased versions.

Here the commit ids again, for reference:

http://git.kernel.org/tip/14fb57dccb6e1defe9f89a66f548fcb24c374c1d
http://git.kernel.org/tip/328935e6348c6a7cb34798a68c326f4b8372e68a

Thanks.

On Tue, May 17, 2011 at 02:55:17PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi all,
> 
> the following 2 patches address the fallout caused by
> b87cf80af3ba4b4c008b4face3c68d604e1715c6. They enable ARAT only on
> Fam10h and later, and leaves out K8 due to multiple problems there.
> 
> Although the patches look almost trivial, I'd like to ask Nick and
> Jörg-Volker to test them, please, so that we can have a confirmation,
> just in case.
> 
> Then, if we're lucky and Linus hasn't released .39 yet, we might sneak
> them in, if we ask people politely :).
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
