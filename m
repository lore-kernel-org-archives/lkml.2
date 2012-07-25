Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2GYSYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:24:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2GYSYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:24:04 -0400
Date: Wed, 25 Jul 2012 15:23:55 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH 15/19] perf tools: use XSI-complaint version of
 strerror_r() instead of GNU-specific
Message-ID: <20120725182355.GD17355@infradead.org>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
 <1343238094-12481-16-git-send-email-acme@infradead.org>
 <20120725175459.GA4878@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725175459.GA4878@shutemov.name>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 25, 2012 at 08:54:59PM +0300, Kirill A. Shutemov escreveu:
> Could you take subject from updated patch? This one:
> 
> perf: fix strerror_r() usage

Sorry, missed that :-\ I think it was because you didn't send the new
patch on its own, but keeping the old subject line and inlining the new
patch at the end of the message, please do it next time.

Ingo, what is your take on this, do you want me to fix this up and
resubmit?

- Arnaldo
