Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2E3BbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:31:25 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41582 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2E3BbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:31:23 -0400
Date: Tue, 29 May 2012 22:31:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] perf ui: Add basic error handling for GTK2 front-end
 (v3)
Message-ID: <20120530013118.GA11319@infradead.org>
References: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 29, 2012 at 01:22:55PM +0900, Namhyung Kim escreveu:
> Hi,
> 
> This patchset implements ui__warning/error() functions for GTK2.
> Patch 1 is a resend (which forgot to cc LKML) and independent of
> this series. Patch 2 converts invocations of ui__warning followed
> by exit (or similar effect) into ui__error.

Pekka, all well with you? Acked-by?

- Arnaldo
