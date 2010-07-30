Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0G3Xxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:53:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51366 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0G3Xxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=FlhAcnM+h4Qgtg/JH6jH6W2LA5/KmW785073vgs2lyOIJlKdje4ohWokJBCi+Ag+iO
         HoxrtGUlG0mEkWXRyDmhzqSV7WEoZXDHYt9eXTj6vPXowWe44FrFgejLapy5tBzS7OCj
         H1JWVRzFLZrgtQuyC1aNI3tu9AlY8B0qjBr3Q=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Jul 2010 16:53:18 -0700
Message-ID: <AANLkTi=AuFBwT5AjRdjrkbe3=5d36TNr4Cp=r0VnEogH@mail.gmail.com>
Subject: Using unsigned int for loop counters - better performance for 
	Architectures - urban hacker legend?
To: linux-kernel@vger.kernel.org
Cc: "doug.dahlby" <Doug.Dahlby@atheros.com>, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For good while now I have been using unsigned int for every looper
iterator I implement on the kernel. I remember I picked this practice
up from Jiri but I just tried to look for actual documentation of this
online and could not find much. A simple test would be to run a series
of loop tests on different architectures with a regular int and then
with an unsigned int to see if performance improves but I obviously
don't have access to many machines with varying architectures.

So if you also follow this practice have you actually found evidence
for this practice, have you actually measured performance metrics? Or
is this just a urban hacker legend?

Please CC me as i am not subscribed to lkml.

  Luis
