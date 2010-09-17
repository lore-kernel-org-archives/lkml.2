Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0IQUHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:07:08 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:34597 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0IQUHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:07:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19603.51810.601209.98683@pilspetsen.it.uu.se>
Date: Fri, 17 Sep 2010 22:06:58 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, robm@fastmail.fm,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: Issue in using mmap on ARM target
In-Reply-To: <AANLkTi=VS34cbaH9TNA9aZ7mVavoTaAiAwMfuRXSxbd8@mail.gmail.com>
References: <AANLkTi=VS34cbaH9TNA9aZ7mVavoTaAiAwMfuRXSxbd8@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

naveen yadav writes:
 > Hi all,
 > 
 > I am facing one issue when executing below progmra on ARM target. The
 > same program work well on X86 host machine,
 > 
 > When execute on Host(x86). the result are as expected.
 > [root@localhost naveen]# ./a.out  0000 b 2
 > /dev/mem opened.
 > Memory mapped at address 0xb7f00000.
 > Value at address 0x0 (0xb7f00000): 0x24
 > Written 0x2; readback 0x2
 > 
 > But when execute on Target:
 > # ./a.out 0 w 20
 > /dev/mem opened.
 > Memory mapped at address 0x40003000.
 > Value at address 0x0 (0x40003000): 0xEA000006
 > Written 0x14; readback 0xEA000006
 > #
 > The value does not change. any idea ....

You might have better luck getting an informed answer by posting
to linux-arm-kernel@lists.infradead.org instead.
