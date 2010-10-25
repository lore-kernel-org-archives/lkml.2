Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0JYKCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:02:31 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:52562 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab0JYKCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:02:30 -0400
/m: 
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Oct 2010 12:02:19 +0200
From: Richard Weinberger <richard@nod.at>
To: <viro@zeniv.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <jdike@addtoit.com>
Subject: um: function "foo" in kernel-offsets.h
Message-ID: <411721a3e73b6124ae8ed348fb13847b@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Your commit a31769ed ("uml: cross-build support : kernel_offsets")
adds this function to kernel-offsets.h:

---cut---
void foo(void)
{
#include <common-offsets.h>
}
---cut---

What is the purpose of foo?

Thanks,
//richard

