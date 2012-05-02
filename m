Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2ECO0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:26:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64766 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756183Ab2ECO0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:26:04 -0400
Date: Wed, 2 May 2012 16:03:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/7] perf ui: Introduce struct perf_error_ops
Message-ID: <20120502190307.GF5745@infradead.org>
References: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com>
 <1335761711-31403-7-git-send-email-namhyung.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335761711-31403-7-git-send-email-namhyung.kim@lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 30, 2012 at 01:55:10PM +0900, Namhyung Kim escreveu:
> The struct perf_error_ops is for flexible error logging.
> We can register appropriate functions based on front-end.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> +
> +	perf_error__register_functions(&perf_tui_eops);

just perf_error__register() is enough, I think.


- Arnaldo
