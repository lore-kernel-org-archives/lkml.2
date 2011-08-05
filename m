Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1HERe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:34:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34898 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1HERe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:34:57 -0400
Date: Fri, 5 Aug 2011 14:34:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        632923@bugs.debian.org, Christian Ohm <chr.ohm@gmx.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: do not look at ./config for configuration
Message-ID: <20110805173447.GC14925@ghostprotocols.net>
References: <20110707024506.GA32088@moongate.localnet>
 <1310010913.4280.36.camel@localhost>
 <20110805165838.GA7237@elie.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805165838.GA7237@elie.gateway.2wire.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 05, 2011 at 06:58:38PM +0200, Jonathan Nieder escreveu:
> In addition to /etc/perfconfig and $HOME/.perfconfig, perf looks for
> configuration in the file ./config, imitating git which looks at
> $GIT_DIR/config.  If ./config is not a perf configuration file, it
> fails, or worse, treats it as a configuration file and changes
> behavior in some unexpected way.
> 
> "config" is not an unusual name for a file to be lying around and perf
> does not have a private directory dedicated for its own use, so let's
> just stop looking for configuration in the cwd.  Callers needing
> context-sensitive configuration can use the PERF_CONFIG environment
> variable.

Thanks, I'll apply this one.

- Arnaldo
