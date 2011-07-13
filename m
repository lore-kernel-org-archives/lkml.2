Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1GMNGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:06:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52221 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1GMNGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:06:22 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110713065737.GA4201@core.coreip.homeip.net>
References: <1310454831.16511.1.camel@phoenix> <20110713065737.GA4201@core.coreip.homeip.net>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 13 Jul 2011 21:06:02 +0800
Message-ID: <CAF+7xW=GfZsgH8JSzCt0pbtV7Wmfe4pDKJiO=Nx-Z2S0XDdZ3Q@mail.gmail.com>
Subject: Re: [PATCH] Input: intel-mid-touch - remove pointless checking for
 variable 'found'
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Sreedhara Murthy. D.S" <sreedhara.ds@intel.com>,
        linux-input@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/13 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Tue, Jul 12, 2011 at 03:13:51PM +0800, Axel Lin wrote:
>> The implementation does break from the for loop after we assign i to variable
>> 'found'.
>>
>
> Hmm, if we are cleaning this up what about the following?
>
hi Dmitry,
It looks good and better.

Thanks,
Axel
