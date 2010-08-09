Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0HII7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:59:21 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32967 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0HII7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <201008091603464245121@gmail.com>
References: <201008091603464245121@gmail.com>
Date: Mon, 9 Aug 2010 09:59:14 +0100
Message-ID: <AANLkTin4LygQPrXgEmLDw1_q241MYp_rqT3Gt7zbMRn8@mail.gmail.com>
Subject: Re: how to transplant a driver from 2.4 to 2.6?
From: Valeo de Vries <valeo@valeo.co.cc>
To: hacklu <embedway.linux@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 August 2010 09:03, hacklu <embedway.linux@gmail.com> wrote:
>  I have a driver project programmed under the 2.4 kernel.
> but now ,I want to transplant it to 2.6.
> the driver has some directions;
> like 1/1.c  2/2.c  3/3_1.c 3_2.c
> in this case ,how can I imtate the   template Makefile   of 2.6's driver
>
> [...]

Fortunately for me, I've not been unlucky enough to need to port 2.4
drivers myself, so I can't tell you the exact steps. However there are
many articles and guides on the 'net that can: a google search for
"linux kernel porting driver 2.4 2.6" will suffice; just look at the
first few hits. If you need more help on Kconfig this may also help
you: http://www.kernel.org/doc/Documentation/kbuild/kconfig-language.txt
.

Valeo
