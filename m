Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1FUKvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:51:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49906 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1FUKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=rMOtpQ4SkMAuFyJOwb9o5QJ0xiGJSuVPoTQZE9FJ5nIW84ujGbc1GJjGyNvJsGPyxe
         RjCr2gSrjcvzJ9yqm6q/41OUSWIXHBHkeiSexR3eNs4w0oivGjZcbsgcMv7TZYDb0XeH
         8xqskzILeo6jA2ars1EHdAyk5GPIyvq9odKhI=
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 21 Jun 2011 12:50:57 +0200
Message-ID: <BANLkTi=u8MaGWayiW92SV44P5URpOO9TXQ@mail.gmail.com>
Subject: gma500: Whats needed to add support for 8086:4108
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi community,

I am trying to get linux with X11 running on a system with a

VGA compatible controller [0300]: Intel Corporation Atom Processor
E6xx Integrated Graphics Controller [8086:4108] (rev 03)

I had a quick look at the gma500 driver, but it does not support this
device. So whats needed to add support for my device
in the gma500 driver? I am not sure if I simply can add the my device
id to the driver without breaking my the graphics controller.

Thanks,
--
Christian Gmeiner, MSc
