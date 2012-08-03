Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2HCOPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:15:54 -0400
Received: from shutemov.name ([176.9.204.213]:44374 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2HCOPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:15:53 -0400
Date: Fri, 3 Aug 2012 17:17:03 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 03/18] perf target: Fix check on buffer size
Message-ID: <20120803141703.GA19736@shutemov.name>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
 <1344002470-5965-4-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344002470-5965-4-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 11:00:55AM -0300, Arnaldo Carvalho de Melo wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It was a mistake just replace assert to BUG_ON since its condition
> should be negated. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ulrich Drepper <drepper@gmail.com>
> Link: http://lkml.kernel.org/r/1343267410-7758-1-git-send-email-namhyung@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov
