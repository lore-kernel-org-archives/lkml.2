Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0LMTrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:47:06 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50253 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab0LMTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=jcbYh/jPcIIr2PZjq25xNiBEjIHKEY/d6Uxc6OqyetSouz24caU6bswo29nUeQlrp6
         ubW4aZvvlaBrH9f19LNW1+pfw4hRG5NrC+LAL1oBozg2n7XYCEMluHOxYLe32zSJVcZY
         MD/Ai8344IG5o/Sl4y+/nkV+nQYWhAUUnCJes=
Date: Mon, 13 Dec 2010 22:46:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] perf: off by one in perf_swevent_init()
Message-ID: <20101213194641.GH1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20101024195041.GT5985@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024195041.GT5985@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 09:50:42PM +0200, Dan Carpenter wrote:
> The perf_swevent_enabled[] array has PERF_COUNT_SW_MAX elements.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Ping.

regards,
dan carpenter

