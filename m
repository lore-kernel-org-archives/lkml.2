Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0LUSgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:36:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36137 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0LUSgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:36:21 -0500
Date: Tue, 21 Dec 2010 10:34:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 8/11] Touch: Touch screen module of DA9052 device
 driver
Message-Id: <20101221103425.42f58c28.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikGsK7-5mBxBHjdf9sa4vYQpV+cvGoMr1ig-8S5@mail.gmail.com>
References: <AANLkTikGsK7-5mBxBHjdf9sa4vYQpV+cvGoMr1ig-8S5@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Dec 2010 19:27:54 +0100 dd diasemi wrote:

> TSI module for DA9052 PMIC device from Dialog Semiconductor.
> 
> Changes made since last submission:
> . added chip specific parameters as platform data.
> 
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>
> diff -Naur A-source/drivers/input/touchscreen/da9052_tsi.c
> B-source/drivers/input/touchscreen/da9052_tsi.c
> --- A-source/drivers/input/touchscreen/da9052_tsi.c	1970-01-01
> 05:00:00.000000000 +0500
> +++ B-source/drivers/input/touchscreen/da9052_tsi.c	2010-12-08
> 15:51:26.000000000 +0500

Long lines above have been split by your email app or some mail server.

There is some possible help in Documentation/email-clients.txt.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
