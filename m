Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab1ANRtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:49:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63409 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab1ANRtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wMBIDDkqRDx84ovJH63DyluyzQX7zWraFSHAeMGjqWwVp8s3yq0lnCcKWSrJ7eBEN0
         +8zHslBZOGKF7/MkdZz9vwRkC3cNFPhAX7K3Pb+gICHt1GSnA7o2y/oQ2A49ecxwOrQN
         hso4Vmr6ViiQ/7dp7r2h5wSLsvFm/KLv69ajI=
Date: Fri, 14 Jan 2011 18:49:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: remove syscall_exit_fields
Message-ID: <20110114174928.GA1926@nowhere>
References: <4D301C0E.8090408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D301C0E.8090408@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 05:49:02PM +0800, Lai Jiangshan wrote:
> 
> Use event_class_syscall_exit.fields instead.
> Remove syscall_exit_fields.
> Remove  syscall_get_enter_fields()

I assume you meant syscall_get_exit_fields()

> Add event_class_syscall_exit.fields initialization.
> 
> Indentation has to be changed also, otherwise the line
> ".fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),"
> I added will exceed 80 characters.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Nice!

Steve, if you don't mind I'll handle that one as I have another
patch for syscalls tracing. 

Thanks.
