Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0KIQ4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:56:51 -0500
Received: from mail4.comsite.net ([205.238.176.238]:27896 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0KIQ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:56:48 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Ramya Desai <ramya.desai@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimPOAN2JSiYEQJ7VOQxVStzFxpStngZD2kepf7J@mail.gmail.com>
References: <AANLkTimPOAN2JSiYEQJ7VOQxVStzFxpStngZD2kepf7J@mail.gmail.com>
Date: Tue, 09 Nov 2010 10:56:48 -0600
Subject: (No subject header)
X-Originating-IP: 71.22.127.106
Message-ID: <1289321808_14292@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue Nov 09 2010 around 02:27:38 EST, Ramya Desai wrote:
> I did not understand the CRTSCTS preprocessor macro which is defined
> in termbits.h file.
..
> As per the typedefs defined in the beginning of the file, the c_cflag
> is unsigned int member in the struct termios structure. The CRTSCTS is
> defined in the file as a 48 bit value.
> 
> #define CRTSCTS 020000000000 /* flow control */

That is not a 48 bit value.

> 
> I saw the following snippet in one of the serial applications.
> 
> struct termios newtio;
> newtio.c_cflag = B9600 | CRTSCTS | CS8 | CLOCAL | CREAD;
> 
> My question is, the c_cflag is a 32 bit value member and the CRTSCTS
> is a 48 bit value. How CRTSCTS is accommodates into c_cflag variable?
> Please let me know, if my interpretation is wrong.
> 
> Thanks in advance.

Hint: constants in C may be expressed in base 16, 10, or 8.

milton
