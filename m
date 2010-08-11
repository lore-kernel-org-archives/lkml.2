Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0HKVhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 17:37:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28409 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0HKVhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 17:37:23 -0400
Date: Wed, 11 Aug 2010 14:35:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: davidsen@posidon.tmr.com
Cc: Bill Davidsen <davidsen@tmr.com>,
        Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-git10 build failure
Message-Id: <20100811143531.8b167336.randy.dunlap@oracle.com>
In-Reply-To: <4C6316B3.5090203@tmr.com>
References: <4C6316B3.5090203@tmr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 17:31:31 -0400 Bill Davidsen wrote:

>   config generated with "make localmodconfig"
> build with "make -j2"
> x86_64 target and host, config and log attached. Host is FC13 current 
> test machine


This part of the build log would be sufficient:

drivers/media/video/v4l2-ctrls.c: In function ___v4l2_ctrl_handler_init___:
drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of function ___kzalloc___
drivers/media/video/v4l2-ctrls.c:767: warning: assignment makes pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ___v4l2_ctrl_handler_free___:
drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of function ___kfree___
drivers/media/video/v4l2-ctrls.c: In function ___handler_new_ref___:
drivers/media/video/v4l2-ctrls.c:896: warning: assignment makes pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ___v4l2_ctrl_new___:
drivers/media/video/v4l2-ctrls.c:975: warning: assignment makes pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ___v4l2_g_ext_ctrls___:
drivers/media/video/v4l2-ctrls.c:1528: error: implicit declaration of function ___kmalloc___
drivers/media/video/v4l2-ctrls.c:1528: warning: assignment makes pointer from integer without a cast
drivers/media/video/v4l2-ctrls.c: In function ___try_set_ext_ctrls___:
drivers/media/video/v4l2-ctrls.c:1752: warning: assignment makes pointer from integer without a cast
make[3]: *** [drivers/media/video/v4l2-ctrls.o] Error 1


Patch for this has been posted 3 times AFAIK.  Hope it gets merged into
mainline soon.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
