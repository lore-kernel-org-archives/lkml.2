Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0LLOkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 09:40:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36155 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab0LLOkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 09:40:03 -0500
Date: Sun, 12 Dec 2010 12:39:48 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        tom.leiming@gmail.com, acme@ghostprotocols.net
Subject: Re: [PATCH 3/3] perf, powerpc: Allow perf test to handle PowerPC
	symbol naming
Message-ID: <20101212143948.GA20240@ghostprotocols.net>
References: <1290658375-10342-1-git-send-email-imunsie@au1.ibm.com> <1290658375-10342-3-git-send-email-imunsie@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290658375-10342-3-git-send-email-imunsie@au1.ibm.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 25, 2010 at 03:12:55PM +1100, Ian Munsie escreveu:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> The PowerPC ABI prefixes symbol names with periods, which causes perf
> test to fail when it compares the symbol from the vmlinux file with the
> symbol names from kallsyms. This patch adds the infrastructure to allow
> archs to override how symbol names are compared and implements the
> PowerPC function to disregard any prefixed periods, allowing perf test
> to pass.

Hi Ian,

	I guess we can apply this one now? Or do you have anything
newer?

- Arnaldo
