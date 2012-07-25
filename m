Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2GYRyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:54:06 -0400
Received: from shutemov.name ([176.9.204.213]:44252 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2GYRyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:54:04 -0400
Date: Wed, 25 Jul 2012 20:54:59 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 15/19] perf tools: use XSI-complaint version of
 strerror_r() instead of GNU-specific
Message-ID: <20120725175459.GA4878@shutemov.name>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
 <1343238094-12481-16-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343238094-12481-16-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you take subject from updated patch? This one:

perf: fix strerror_r() usage

-- 
 Kirill A. Shutemov
