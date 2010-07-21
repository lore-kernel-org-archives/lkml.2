Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab0GUP5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:57:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230Ab0GUP5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:57:18 -0400
Message-ID: <4C4718D5.1080902@kernel.org>
Date: Wed, 21 Jul 2010 17:57:09 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: linux-s390@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [-next July 21] s390 build failure : kernel/workqueue.o
References: <4C46CEA3.7040503@in.ibm.com>
In-Reply-To: <4C46CEA3.7040503@in.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 15:57:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/21/2010 12:40 PM, Sachin Sant wrote:
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

Hmmm... that's surprising.  Can you please attach the .config?

Thanks.

-- 
tejun
