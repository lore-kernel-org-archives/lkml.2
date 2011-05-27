Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1E0RZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:25:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54941 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab1E0RZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=se4hhkdXsp22PuSsQpPCSMgmFxpBBb6AWjDrOdxJNr3NgBbok2Ya7tTRfqeqdzcLVY
         6oVBPuSaZtyxTx30ErhixSeP0l3szU2ChTfrQf58wHsVOTAIkdfWt7MMlFKXB7N5OQOq
         nsTxUIehflcnyvUVyFqDzZ4kheQ52fWORRU/M=
Date: Fri, 27 May 2011 14:25:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf stat: clarify unsupported events from uncounted
 events
Message-ID: <20110527172525.GA10352@ghostprotocols.net>
References: <1306515106-11967-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306515106-11967-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 27, 2011 at 10:51:46AM -0600, David Ahern escreveu:
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index f79bb2c..57eccf1 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -61,6 +61,7 @@ struct perf_evsel {
>  		off_t		id_offset;
>  	};
>  	struct cgroup_sel	*cgrp;
> +	int supported;
>  };

Can you make this be just a 'bool'?

- Arnaldo
