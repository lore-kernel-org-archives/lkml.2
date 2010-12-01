Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0LABGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:06:06 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53909 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0LABGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:06:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=DJ55VAVoAK629QaN7kMpg+tKEBq/FnHxOP0iavN/Z9meLEPKNupCnEqqIASrX/MuXF
         3c8H0P+t7hlYEuoJck+0SCSBFqQUSMJSjfpFq1amsnBblRyiDSrGCrAXMPrfJUBjbVsM
         dvt4sWczO9EGXOi1rpItIS4LbzupR8QkyrzPo=
Date: Tue, 30 Nov 2010 23:05:58 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tools: fix event parsing of comma-separated
 tracepoint events
Message-ID: <20101201010558.GA10966@ghostprotocols.net>
References: <1291156021-17711-1-git-send-email-cjashfor@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291156021-17711-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 30, 2010 at 02:27:01PM -0800, Corey Ashford escreveu:
> There are number of issues that prevent the use of multiple tracepoint
> events being specified in a -e/--event switch, separated by commas.
> 
> For example, perf stat -e irq:irq_handler_entry,irq:irq_handler_exit ...
> fails because the tracepoint event parsing code doesn't recognize the
> comma separator properly.
> 
> This patch corrects those issues.

Thanks, applied.
 

- Arnaldo
