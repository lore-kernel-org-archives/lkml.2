Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1HJRMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 13:12:01 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:57507 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1HJRMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 13:12:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAEgfSJho=MUS+gDrb-b9dJhP7dX4zTBW3jL98jpxVUDssyEX9w@mail.gmail.com>
References: <1312931618-14470-1-git-send-email-kolymine@gmail.com>
	<20110810021719.GB23748@kroah.com>
	<CAEgfSJho=MUS+gDrb-b9dJhP7dX4zTBW3jL98jpxVUDssyEX9w@mail.gmail.com>
Date: Wed, 10 Aug 2011 19:11:59 +0200
Message-ID: <CAEgfSJh05XDxb_-56GJdQKsULDPz8b7XAvoSjpP0w5w=c6=C1A@mail.gmail.com>
Subject: Fwd: [PATCH] Staging : winbond : fix coding style issue in phy_calibration.c
From: Kolymine <kolymine@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kolymine <Kolymine@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Greg,
i have (mis)used it.
Will check what happened tonight

Regards,
Vincent

Le 10 août 2011 04:17, "Greg KH" <greg@kroah.com> a écrit :
> On Wed, Aug 10, 2011 at 01:13:38AM +0200, Kolymine wrote:
>> Thus us a patch to the phy_calibration.c file that fixes up coding style warning found by the checkpatch.pl tool
>>
>> Signed-off-by: Vincent Abel-Grimalt <kolymine@gmail.com>
>> ---
>> drivers/staging/winbond/phy_calibration.c | 12 ++++++------
>> 1 files changed, 6 insertions(+), 6 deletions(-)
>
> Please use the scripts/get_maintainer.pl tool to determine who to send
> patches to, so they don't get lost.
>
> I've picked this one up for now, but please be more careful in the
> future.
>
> greg k-h
