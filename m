Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0KGOai (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 09:30:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0KGOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 09:30:37 -0500
Message-ID: <4CD6B7FA.3050005@redhat.com>
Date: Sun, 07 Nov 2010 15:30:18 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100918 Thunderbird/3.1.4
MIME-Version: 1.0
To: Matt <jackdachef@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
In-Reply-To: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/06/2010 11:16 PM, Matt wrote:
> before diving into testing out 2.6.37-rc* kernels I wanted to make
> sure that the patch:
> 
> [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
> 
> is safe to use with e.g. >2.6.37-rc1 kernels
> 
> I know that it's not a "fix all" patch but it significantly seems to
> speed up my backup jobs (by factor 2-3)
> and 2.6.37* has evolved that much that interactivity isn't hurt too much

yes, it should work for the simple mappings without problems.

I hope we will fix the patch soon to be ready for upstream.

Milan
