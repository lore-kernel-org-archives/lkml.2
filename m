Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab0DLN35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:29:57 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51798 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0DLN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=XMcET2IgPyP+r/R1TkG2z+s/vjN9I30Xv1urfthXGpbN5e2FyI1biUWzLkaP8ESsna
         LAqIMiI41+MGVO6QBvk8FvQw/kadsDQnW9A3dwM4DjE6Ls5JrYRvny3t6Nn4qXUMGmPh
         ycLn0NCYro3xu5MzpF/zUO3q1wwLUbJS1Y6FU=
MIME-Version: 1.0
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Mon, 12 Apr 2010 15:28:37 +0200
Message-ID: <h2i45cc95261004120628kb38aabecr2552668f9e60d7c5@mail.gmail.com>
Subject: Low-Level and Long-Term Battery Control
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any function in the Linux kernel that control the
charging/discharging of the battery to provide better lifespan ?
(add some years to its life ?)

For Laptops, it is better to extract the battery from the Laptop when
the computer will be on power for a long period.
I ask if the kernel can do such control without the user intention and
in an automatic way.

Some BIOS provide to the user to select whether to block the battery
charging to 50% to make it stand for more time.
And Many people (like me) forget their laptops on power until the
battery no more can hold energy after 2minutes of no power.

I am not sure for the MacBook side, but it seems they don't suffer
from such problem in the same degree as other laptop users.

I think it is a serious problem because if you keep you battery on
power for one week you will detect it becomes holding only 50% of its
energy compared to when first bought.

Thanks,

Mohamed-Ikbel BOULABIAR
