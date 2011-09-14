Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1INXdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 19:33:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39328 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1INXdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 19:33:44 -0400
Date: Thu, 15 Sep 2011 08:33:35 +0900
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCHSET cgroup] extend threadgroup locking
Message-ID: <20110914233335.GQ29319@htj.dyndns.org>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <20110911033536.GO29319@htj.dyndns.org>
 <20110914183354.GA16922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914183354.GA16922@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 14, 2011 at 08:33:54PM +0200, Oleg Nesterov wrote:
> OK, I'll try to read it this week when I get recovered, I am ill now.
> 
> But I got lost... What about
> 
> 	http://thread.gmane.org/gmane.linux.kernel/1184375
> 
> which I didn't read yet? It seems that they conflict with each other.
> 
> Should I ignore the series above? Probably yes, it surely conflicts
> with the task-counter patches in -mm.

Yeah, that one will be rebased on top of this one (and hopefully
task-counter on top of that).

Thanks.

-- 
tejun
