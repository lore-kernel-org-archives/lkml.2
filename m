Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0GDP5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 11:57:10 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61265 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0GDP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 11:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PHVuf/7/vzbU2AvMjKQVU+FkZzKilQhaqnlLzXIOQP3yOylCrI0boyZysnDCgEpOzM
         WQhTC4yARHgnuCPC11Gmyg3/Sg+BGyGLN6XEcb3+oyk05zpbjipbtQcanBM7LHdKSpmr
         vk+zaysg5aNgN5kAQFwC3DoCEQAPSmFEv5K0k=
MIME-Version: 1.0
In-Reply-To: <AANLkTikhv1JxmAS8wYksEELII-5YzKi-a5by0EV_ESYH@mail.gmail.com>
References: <cover.1277911345.git.siccegge@cs.fau.de> <e9515441013afc8e866f3081dd35bbe0122ece5e.1277911346.git.siccegge@cs.fau.de> 
	<AANLkTikhv1JxmAS8wYksEELII-5YzKi-a5by0EV_ESYH@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 4 Jul 2010 23:56:46 +0800
Message-ID: <AANLkTilRaITmDNfN03RyA4Hj9EmIFnDIy6KbOPlaLzdu@mail.gmail.com>
Subject: Re: [PATCH 26/33] Removing dead XSCALE_CACHE_ERRATA
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de, Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 12:25 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Thu, Jul 1, 2010 at 12:02 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> XSCALE_CACHE_ERRATA doesn't exist in Kconfig, therefore removing all
>> references for it from the source code.
>>
>> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>
> Acked-by: Eric Miao <eric.y.miao@gmail.com>
>
> It's not been there since 2.6, found some references in 2.4 kernel though. And
> I doubt anyone has encountered this issue in real products on market.
>

Applied.
