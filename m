Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978Ab0J0O6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:58:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48669 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0J0O6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K8WCo2zlwq8CfQ5D0zmt35oxi3+W1NeMQPwNCvFYleQMqhWY7jq4Vi3KyUBRw5LicK
         lD6LKeaz6GY9Y4QvBLcIGzL2ql0xTtp2UC6baF0vvAnuP3YDSWCyAKNoZoy7sXeXG9fY
         y/Ct6P92MFnE6dQ/AZBOC65/mcFYkaOR69nf0=
MIME-Version: 1.0
In-Reply-To: <201010261406.10996.arnd@arndb.de>
References: <AANLkTineXA2ZY0J7+dZhqywz+4aAVgzihu+LDDbsL8mu@mail.gmail.com>
	<201010221736.57671.arnd@arndb.de>
	<AANLkTinY0qmt6uFo4PZ3xH2BF5-AJ0C7ptctzNdOkRU2@mail.gmail.com>
	<201010261406.10996.arnd@arndb.de>
Date: Wed, 27 Oct 2010 10:58:02 -0400
Message-ID: <AANLkTi=wkXHRTvaZCivrgthK=0riEL=j7-m=S6kTHw+5@mail.gmail.com>
Subject: Re: [PATCH 1/9] mfd: Add support for the ST-Ericsson CG2900.
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/26 Arnd Bergmann <arnd@arndb.de>:

> If CG2900 is a single
> piece of silicon that always looks the same way, it's probably an MFD.

It is:
http://www.stericsson.com/product/223489.jsp

So atleast we have that part right :-)

(And thanks for all the good feedback Arnd, really appreciated!)

Yours,
Linus Walleij
