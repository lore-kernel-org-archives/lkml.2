Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0GVHWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 03:22:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63463 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0GVHWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 03:22:31 -0400
Message-ID: <4C47F0EC.5040507@petalogix.com>
Date: Thu, 22 Jul 2010 09:19:08 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [-next July 21] s390 build failure : kernel/workqueue.o
References: <4C46CEA3.7040503@in.ibm.com>
In-Reply-To: <4C46CEA3.7040503@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Sant wrote:
> Today's next fails to build on a s390 box with
> 
>  CC      kernel/workqueue.o
> kernel/workqueue.c: In function 'init_workqueues':
> kernel/workqueue.c:3525: error: negative width in bit-field '<anonymous>'
> make[1]: *** [kernel/workqueue.o] Error 1
> 
> Yesterday's next was good.
> The following patches added/changed the BUILD_BUG_ON() statement.
> 
> bdbc5dd7de5d07d6c9d3536e598956165a031d4c
>        workqueue: prepare for WQ_UNBOUND implementation
> 7a22ad757ec75186ad43a5b4670fa7423ee8f480
>         workqueue: carry cpu number in work data once execution starts
> 
> I have gcc version 4.3.2 installed on the system.

the same problem on microblaze gcc 4.1.2.

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
