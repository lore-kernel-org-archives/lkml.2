Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab2HOKsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:48:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52258 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab2HOKsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:48:42 -0400
Date: Wed, 15 Aug 2012 13:48:38 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Namhyung Kim <namhyung@kernel.org>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 7/7] perf gtk/browser: Use hist_period_print functions
In-Reply-To: <1344243462-28403-8-git-send-email-namhyung@kernel.org>
Message-ID: <alpine.LFD.2.02.1208151348200.10388@tux.localdomain>
References: <1344243462-28403-1-git-send-email-namhyung@kernel.org> <1344243462-28403-8-git-send-email-namhyung@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Namhyung Kim wrote:
> Now we can support color using pango markup with this change.
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Awesome!

Acked-by: Pekka Enberg <penberg@kernel.org>
