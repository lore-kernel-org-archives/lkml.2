Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0FTWCX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:02:23 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:48155 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab0FTWCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:02:21 -0400
X-Greylist: delayed 1669 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jun 2010 18:02:21 EDT
Message-ID: <4C1E8952.7010503@cs.columbia.edu>
Date: Sun, 20 Jun 2010 17:34:10 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoffer Dall <christofferdall@christofferdall.dk>
CC: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [C/R ARM v2][PATCH 0/3] Linux Checkpoint-Restart - ARM port
References: <1272318223-28438-1-git-send-email-christofferdall@christofferdall.dk>
In-Reply-To: <1272318223-28438-1-git-send-email-christofferdall@christofferdall.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

On 04/26/2010 05:43 PM, Christoffer Dall wrote:
> Following there will be two preparatory patches for an ARM port of the
> checkpoint-restart code and finally a third patch implementing the
> architecture-specific parts of c/r.
> 
> The preparatory patches consist of a partial syscall trace implementation
> for ARM and an eclone implementation for ARM. The syscall trace
> implementation provides only the needed functionality for c/r.
> 
> There is a separate patch for the user space code, which supports
> cross-compilation, extracting headers for ARM and an eclone implementation
> for ARM.
> 
> The kernel patches presented here are based on the ckpt-v21-rc6 patch set.
> 
> ---
> 
> CHANGELOG:
> 
> [2010-Apr-08] v2:
> 	- Systrace implementation now inspects process state to get the
> 	  system call number thereby avoiding extra work on system calls.
> 	- Removed __user attribute on long type in eclone implementation
> 	- Better check for architecture versions across C/R
> 	- Improved checking of user space ABI settings across C/R
> 	- Code simplifications
> 
> [2010-Mar-22] v1:
> 	- Initial version
> 	- Systrace implementation modified the system call entry path to
> 	  store the system call number globally in memory.
> 	- ARM implementation lightly tested
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
