Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1JSRWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1JSRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:22:53 -0400
Message-ID: <4E9F0753.1010206@redhat.com>
Date: Wed, 19 Oct 2011 15:22:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
References: <1319035866-29570-1-git-send-email-bp@amd64.org> <1319035866-29570-3-git-send-email-bp@amd64.org> <987664A83D2D224EAE907B061CE93D5301F19DBDB5@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301F19DBDB5@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 19-10-2011 15:13, Luck, Tony escreveu:
>> Start relocating RAS features into a centralized location under
>> arch/x86/kernel/cpu/ras/. Readjust Kconfig items and makefiles
>> accordingly.
> 
> Not all ras features are "cpu" orientated ... should we really be
> moving to "arch/x86/kernel/ras"?

I think that it makes sense to move MCA bits into arch/x86, but I agree
with Tony: generally speaking, RAS is not even x86 specific.

It seems to make more sense to rename drivers/edac to drivers/ras and put
the RAS menu there, even if the actual support for the AMD and Intel MCA
RAS stuff is kept inside arch/x86/...

Mauro

> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

