Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab0FBMIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:08:36 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45037 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab0FBMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:08:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vzVlbC8BGSdhnzA0UWBlTtwF+XhARf8njaMl94kt1IYGnYcR/aS1xcEc0VRikTlmAx
         bYyJvV3mQHUd9ioFtbCM0JBlp5ZRGxQiMPxCw8dHMGMrWAwih1q/0L9DZSvoig/6FQXq
         ggiMT98IalbUjn4TnggOxr6B623pP5Gp0ljkA=
MIME-Version: 1.0
Date: Wed, 2 Jun 2010 12:08:33 +0000
Message-ID: <AANLkTinfWMJ94pPxjRAx-vgvcqSwE9Hw3kHqEDLazhZ2@mail.gmail.com>
Subject: Is there a way to change irq numbers of pcie cards ?
From: Bert dd <bert.ddecker@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Is there a way to change irq numbers of pcie cards ?

I have a supermicro machine with 2 raid cards (lsi 9260-8i and lsi 9260-8e) and
one nvidia GTX480 graphics card.
The problem is that all these pcie cards are assigned the same irq number,
and thus all the interrupts are routed to the same cpu which can not
handle this.
If I replace the nvidia GTX480 with an older graphics card(too old for
our purposes (GTX295)), the graphics card gets a different irq number
than the raid cards, the interrups of the graphics card are handled by
a different cpu than those of the raid cards, and the read/write speed
of the raid increases.
I am reading/writing at 2.5 GB/s to the raid and I am uploading
textures at 0.5 GB/s to the graphics hardware.
Is there a way to change the irq numbers of the pcie cards ?
I am using IOAPIC for interrupt routing.
I am using ubuntu - kernel version 2.6.31-14-generic.

thanks,
  Bert De Decker
  bert.dedecker@uhasselt.be
