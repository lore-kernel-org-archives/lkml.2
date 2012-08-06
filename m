Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2HFSMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:12:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60056 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2HFSMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:12:08 -0400
Date: Mon, 6 Aug 2012 15:12:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/3] perf: teach "perf inject" to work with files
Message-ID: <20120806181202.GE21441@infradead.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
 <1344247319-304069-2-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344247319-304069-2-git-send-email-avagin@openvz.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 06, 2012 at 02:01:57PM +0400, Andrew Vagin escreveu:
> Before this patch "perf inject" can only handle data from pipe.
> 
> I want to use "perf inject" for reworking events. Look at my following patch.
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Patches that add options to commands should include updates to the docs
(tools/perf/Documentation/).

Also something I saw was the const * char versus const char * stuff for
the foo_file variables, please make them consistent.

- Arnaldo
