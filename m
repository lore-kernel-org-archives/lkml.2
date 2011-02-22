Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1BVSJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:09:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64726 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1BVSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:09:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ij+SFrqa6R0bPThpykcT8BGdZZAQ0gW/hTeuOPhCwi9KlzVWaJKGHoILYU5vED+un2
         Adr9bjcKj78mNZTLUTNvhJ1z47iBp+0Qoba0ngBVueihwiGo64raKmkIpv36a5L+5jt1
         P+9HSEYV6hpzEH3zTo2CdlspXCCj+jxboWPsY=
Date: Tue, 22 Feb 2011 19:09:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf lock: clean the options for perf record
Message-ID: <20110222180940.GA1799@nowhere>
References: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298388507-19774-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:28:27AM +0900, Hitoshi Mitake wrote:
> From: Hitoshi Mitake <h.mitake@gmail.com>
> 
> Hi Frederic, really sorry for my slow work...
> 
> This patch cleans the options passed for perf record(or cmd_record()).
> 1. remove ":r" at the tail of the name of events, because it is not supported now
> 2. remove "-f" deprecated option, because it is already default
> 
> Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---

Thanks.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
