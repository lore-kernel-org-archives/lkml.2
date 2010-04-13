Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0DMMnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:43:13 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58550 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0DMMnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=kcFwhRzOw7lHk6CTg9rNycQnehthUaXR1YOOnWxUXMbkfAyQz9kxHIftCz/yFrZ6YI
         hShNR0Cc3DWbmQHbiMIQD2uUux3ePihK0hzbPDvt9jelvPpwge4wzuA8rMQHY/PTH3Ua
         RPWY3BQceyYlBA+VcBqWw11vLtYgCxIzE5Vng=
MIME-Version: 1.0
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Tue, 13 Apr 2010 14:35:01 +0200
Message-ID: <w2r45cc95261004130535y80da503ev5389bb4a97bdd58f@mail.gmail.com>
Subject: Low-Level and Long-Term Battery Control
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
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
