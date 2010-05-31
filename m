Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab0EaKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:25:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63764 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab0EaKZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x2H2NbxPRflIaZ8O8ZlKDiyp+pitFa57/szUlZLWgN7nnmqmRxNwEHWX3+gF6XeQWf
         EmDRpk8+o8q8Q6SPS4xeUXy7U1vUHEwZgvpi/ve0ZuaKxewC2A5ILhOc4JoqgYISycTP
         KU1dPYWTTKxbkJEBp6h2erqZbC3/M53mbhGvM=
Message-ID: <4C038E90.3020008@gmail.com>
Date: Mon, 31 May 2010 12:25:20 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] module: fix reference to mod->percpu after freeing module.
References: <201005252300.07739.rjw@sisk.pl> <201005271456.20003.rusty@rustcorp.com.au> <201005272357.28141.rjw@sisk.pl> <201005311953.51694.rusty@rustcorp.com.au>
In-Reply-To: <201005311953.51694.rusty@rustcorp.com.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 12:23 PM, Rusty Russell wrote:
> Rafael sees a sometimes crash at precpu_modfree from kernel/module.c; it
> only occurred with another (since-reverted) patch, but that patch simply
> changed timing to uncover this bug, it was otherwise unrelated.
> 
> The comment about the mod being freed is self-explanatory, but neither
> Tejun nor I read it.  This bug was introduced in 259354deaa, after it
> had previously been fixed in 6e2b75740b.  How embarrassing.
> 
> Reported-by: "Rafael J. Wysocki" <rjw@sisk.pl>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>

Embarrassingly-Acked-by: Tejun Heo <tj@kernel.org>

Thanks. :-)

-- 
tejun
