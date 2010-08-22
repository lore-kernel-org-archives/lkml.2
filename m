Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0HVIMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 04:12:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0HVIL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 04:11:59 -0400
Date: Sun, 22 Aug 2010 04:11:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100822081157.GA7365@infradead.org>
References: <20100815225359.GA32152@infradead.org>
 <20100819005720.GB5324@nowhere>
 <20100819085700.GB8782@infradead.org>
 <20100819150422.GA325@ghostprotocols.net>
 <20100820091645.GA20138@infradead.org>
 <20100821024713.GD7959@nowhere>
 <20100821144239.GA31202@infradead.org>
 <20100821144625.GA19711@infradead.org>
 <20100822052013.GF5258@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100822052013.GF5258@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 07:20:14AM +0200, Frederic Weisbecker wrote:
> Now does it work with the patch in attachment?
> It includes the previous one.

It works perfectly thanks!  

