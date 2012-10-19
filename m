Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab2JSN0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:26:35 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:48228 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab2JSN0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:26:34 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <3991.124.205.227.162.1350654201.squirrel@mprc.pku.edu.cn>
In-Reply-To: <20121019131811.GJ2616@ZenIV.linux.org.uk>
References: <1350636190-6303-1-git-send-email-gxt@mprc.pku.edu.cn>
    <20121019131811.GJ2616@ZenIV.linux.org.uk>
Date: Fri, 19 Oct 2012 21:43:21 +0800 (CST)
Subject: Re: [PATCH 1/2] unicore32: switch to generic 
     kernel_thread()/kernel_execve()
To: "Al Viro" <viro@ZenIV.linux.org.uk>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Oct 19, 2012 at 04:43:09PM +0800, Guan Xuetao wrote:
>> From: Al Viro <viro@zeniv.linux.org.uk>
>>
>> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> Acked-and-Tested-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
>
> You mean, it worked modulo obvious missing ')'?  Wow... OK, merged
> into signal.git#for-next, obviously in no-rebase mode (as the matter
> of fact, I'm dropping the local branch completely).
>
I've added')' in the patch. Then it works.
In addition, I pushed these two patches into my tree.

Thanks & regards,
Guan Xuetao
