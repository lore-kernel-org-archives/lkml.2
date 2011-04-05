Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1DEOzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:55:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:42604 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1DEOzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:55:00 -0400
Message-ID: <56341.94.211.195.167.1302015286.squirrel@gate.crashing.org>
In-Reply-To: <4D9AE10E.3080501@snafu.de>
References: <4D99B60D.3030009@snafu.de>
    <BANLkTi=mU=v_6gH_5VCwZZmiX+UoqAVf+w@mail.gmail.com>
    <4D99C83A.2080807@snafu.de> <4D9AE10E.3080501@snafu.de>
Date: Tue, 5 Apr 2011 16:54:46 +0200 (CEST)
Subject: Re: [Libusb-devel] Kernel bug message and missing data 
     on	libusb_interrupt_transfer
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: "Oncaphillis" <oncaphillis@snafu.de>
Cc: "Xiaofan Chen" <xiaofanc@gmail.com>, libusb-devel@lists.sourceforge.net,
        "Kernel development list" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm in an environment where we are
>> reluctant to switch between versions. I had a hard time to

> Pid: 14293, comm: E25Stress Tainted: G      D    2.6.30.10 #2 To Be
> Filled By O.E.M.
> RIP: 0010:[<ffffffff8028d2f8>]  [<ffffffff8028d2f8>] kfree+0x7c/0xdb

> Suprisingly now the kernel is reported as tainted although there isn't
> any module inserted the

That is not true; "G" means you have loaded a (GPL-compatible) module.
"D" means the kernel died.  It died because it tried to dealloc memory
using a bad pointer, perhaps a null pointer.

Your kernel is two years old, you should try a current kernel.


Segher

