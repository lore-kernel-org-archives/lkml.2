Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2DBRnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:43:06 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49753 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2DBRnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:43:03 -0400
Date: Mon, 2 Apr 2012 20:43:00 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Namhyung Kim <namhyung.kim@lge.com>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] perf tools: Move UI bits to tools/perf/ui
 directory
In-Reply-To: <1333003004-6391-2-git-send-email-namhyung.kim@lge.com>
Message-ID: <alpine.LFD.2.02.1204022042530.1950@tux.localdomain>
References: <1333003004-6391-1-git-send-email-namhyung.kim@lge.com> <1333003004-6391-2-git-send-email-namhyung.kim@lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, Namhyung Kim wrote:
> Move those files to new directory in order to be prepared to
> further UI work. Makefile and header file pathes are adjusted
> accordingly.
> 
> Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>

Acked-by: Pekka Enberg <penberg@kernel.org>

