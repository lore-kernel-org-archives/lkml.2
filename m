Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1IZO7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:59:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1IZO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:59:06 -0400
Date: Mon, 26 Sep 2011 16:58:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20110926145836.GB8886@jolsa.brq.redhat.com>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <4E808166.7090807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E808166.7090807@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 07:43:02AM -0600, David Ahern wrote:
> 
> 

SNIP

> > +	/*
> > +	 * The '+ 5' is for '/' we add to the patch, plus NULL byte,
> > +	 * and one safety byte ;)
> > +	 */
> > +	file = malloc_or_die(strlen(path) + strlen(sys) +
> > +			     strlen(name) + strlen("format") + 5);
> 
> Why not go the simple route and just use PATH_MAX?
> 
> David

ok, seems more simple.. ;)

thanks,
jirka
