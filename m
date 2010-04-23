Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0DWFor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:44:47 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:62457 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0DWFop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kFIuKFWNjhtkYFtF4ra/d0S11hE3LhEmFSJMMJaTruVYviX8pN8kY1ZYY/UFAmTmui
         6U8xo0RsVtC7x1KD0QvZ3qS2hHwxzh/RLlNe1w2cPuY/St4tY94FC22yUOaZOkB4ShxM
         cNMSBh60lYSCdxxy8jRIVjNY+nS1n6sKzIfLk=
Date: Fri, 23 Apr 2010 13:48:32 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: defconfig strangeness
Message-ID: <20100423054832.GE3995@cr0.nay.redhat.com>
References: <20100422160723.GA13848@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422160723.GA13848@opentech.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 06:07:23PM +0200, Nicholas Mc Guire wrote:
>
>HI !
>
> doing a series of static code analysis on 2.6.34-rcX each of them with 
> defconfig (x86 32bit) - the strangeness is that even though the config
> file is the same for rc3...5 the number of files actually compiled 
> is very different. (linux-2.6 git tree)
>
> 2.6.34-rc5 1695
> 2.6.34-rc4 3404
> 2.6.34-rc3 5109
>
> I diffed the .configs - rc4/rc5 only shows
>
>3,4c3,4
>< # Linux kernel version: 2.6.34-rc4
>< # Thu Apr 22 11:37:43 2010
>---
>> # Linux kernel version: 2.6.34-rc5
>> # Thu Apr 22 10:44:02 2010
>
> why then this large difference in files being compiled ? 
>
> any hint apprecieated.
>

Hmm, interesting.

I guess it would be due to some dependences.

Use the way that you used to find the number of compiled files to
find which files are compiled, make a sorted list and do a diff.

Thanks.
