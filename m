Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab0C1S4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 14:56:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61000 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0C1S4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 14:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aGRMf4Jahi7HNSvAicY4u40cZAZkLStFI1pmzyy9bNIe6dXSQFvNNy/LJxkca1MScQ
         Oof4m98H+bvKycersHgJ/wHr2RtMhh8NUEi5SHtoAxgcz1uushm+9iP4PWbpquWMqaCB
         yzV074E/3wVzqWGF9YD9yCsJkZfFvx5ULtHLw=
Date: Sun, 28 Mar 2010 20:56:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: eduard.munteanu@linux360.ro, mingo@elte.hu, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH] Remove Documentation/trace/kmemtrace.txt
Message-ID: <20100328185647.GB5116@nowhere>
References: <3fa4ae08-42db-4ee0-b86f-567997c35dd4@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa4ae08-42db-4ee0-b86f-567997c35dd4@default>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 09:09:17AM -0700, Randy Dunlap wrote:
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.


Joining the party:

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Btw, how far are we from removing the ftrace plugin, now
that we have the allocator trace events?

Thanks.

