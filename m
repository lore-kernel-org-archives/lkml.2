Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0DVWyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:54:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63189 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0DVWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:54:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dKY7kha4yo7x8MX0dddLGtvvuD4v1vuPGAPAxg/neTKVKIGU9e1vIoRB31qb0E1KXz
         5RAFoaRRcqm+E2MikKOwHcmGIXZ8V7AbwXGqtOr5iVj+aYHaRl/LQcxNYwwnpp7frdem
         ipWAkerGRy5O/JucbMOoVuYQKh9aOIuWIbNYA=
Date: Fri, 23 Apr 2010 00:54:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] perf lock: Fix state machine to recognize lock
	sequence
Message-ID: <20100422225448.GD5600@nowhere>
References: <20100421012651.GC7120@nowhere> <1271852634-9351-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271852634-9351-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 09:23:54PM +0900, Hitoshi Mitake wrote:
> Hi Frederic,
> 
> I'm sending this v2 patch.
> It seems that your tree doesn't contain previous one.
> So could you queue this new one?


Yep, thanks for this work.

I'm applying it.

