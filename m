Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab0GFQsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:48:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58281 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0GFQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:48:44 -0400
Date: Tue, 6 Jul 2010 13:48:37 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Conny Seidel <conny.seidel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       borislav.petkov@amd.com
Subject: Re: [PATCH tip/perf/urgent] perf tools: Fix fallback to
 cplus_demangle() when bfd_demangle() is not available
Message-ID: <20100706164837.GE3861@ghostprotocols.net>
References: <20100706134348.GC26192@ghostprotocols.net>
 <1278430783-17259-1-git-send-email-conny.seidel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278430783-17259-1-git-send-email-conny.seidel@amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 06, 2010 at 05:39:43PM +0200, Conny Seidel escreveu:
> make version 3.80 doesn't support "else ifdef" on the same line, also it
> doesn't support unindented nested constructs.

Thanks, testing this now.
 
- Arnaldo
