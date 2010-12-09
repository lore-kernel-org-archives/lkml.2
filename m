Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab0LIROn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:14:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44972 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0LIROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=FLhzumLQusLI0Xu5wExByqlBS9z+lOnHmlDY5WDCKTblRIDjuI1F8QW2vPA/LTht/u
         BzMxEs+ZA6hjWu3TQqF/kgL5/a22+ghKEc7+HF+0PBjS/Jp9LlIVd3tshIjUzBAZZ/Kx
         54y40vE3vAg8/SV1F4WRrecqnBFLrNJLeJdz0=
Date: Thu, 9 Dec 2010 15:14:36 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH-v2] perf tools: Add symfs option for off-box analysis
 using specified tree
Message-ID: <20101209171436.GA13027@ghostprotocols.net>
References: <1291862020-24540-1-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291862020-24540-1-git-send-email-daahern@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 08, 2010 at 07:33:40PM -0700, David Ahern escreveu:
> The symfs argument allows analysis of perf.data file using a locally
> accessible filesystem tree with debug symbols - e.g., tree created
> during image builds, sshfs mount, loop mounted KVM disk images,
> USB keys, initrds, etc. Anything with an OS tree can be analyzed from
> anywhere without the need to populate a local data store with
> build-ids.
> 
> Signed-off-by: David Ahern <daahern@cisco.com>
> 
> v1 --> v2: removed symfs changes from builtin-annotate.c
>            fixed tab/space inconsistencies
>            changed new strlen() to symbol_conf.symfs[0]
>            added symfs option to Documentation files

So I tried it now with:

perf report --symfs /

Which should be equivalent to the common case:

perf report

Bu kernel symbols didn't got resolved, can you please check this?

- Arnaldo
