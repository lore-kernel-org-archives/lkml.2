Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0DZQOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 12:14:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0DZQOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 12:14:12 -0400
Date: Mon, 26 Apr 2010 13:13:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Fix libdw-dev package name in error message
Message-ID: <20100426161326.GI7460@ghostprotocols.net>
References: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272292023-9869-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 26, 2010 at 03:27:03PM +0100, Stefan Hajnoczi escreveu:
> The headers required for DWARF support are provided by the libdw-dev
> package in Debian-based distros.  This patch corrects the elfutils-dev
> package name to libdw-dev in the Makefile error message when libdw.h is
> not found.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

Thanks, applied
