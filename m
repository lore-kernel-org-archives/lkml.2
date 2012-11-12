Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab2KLHPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:15:41 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51990 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2KLHPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:15:40 -0500
Date: Mon, 12 Nov 2012 09:15:34 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Namhyung Kim <namhyung@kernel.org>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf tools: Add gtk.<command> config option for launching
 GTK browser
In-Reply-To: <1352688617-25570-1-git-send-email-namhyung@kernel.org>
Message-ID: <alpine.LFD.2.02.1211120915190.7164@tux.localdomain>
References: <1352688617-25570-1-git-send-email-namhyung@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Add config option for launching GTK browser for the specified command
> by default.  Currently only 'report' command is supported.
> 
> Adding following line to the perfconfig file will have a same effect
> of specifying --gtk option on command line (unless other related
> options are not given).
> 
> $ cat ~/.perfconfig
> [gtk]
> report = true
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Pekka Enberg <penberg@kernel.org>
