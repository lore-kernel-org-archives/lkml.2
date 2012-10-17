Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab2JQRxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:53:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:46569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab2JQRxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:53:38 -0400
Date: Wed, 17 Oct 2012 10:53:30 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [perf] Account the nr_entries in rblist properly
Message-ID: <20121017175330.GH6807@ghostprotocols.net>
References: <20120831070834.14806.87398.stgit@suzukikp.in.ibm.com>
 <507EED32.7040900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507EED32.7040900@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 17, 2012 at 11:38:58AM -0600, David Ahern escreveu:
> Arnaldo:
> 
> I think this one has fallen through the cracks.

Thanks for catching this, applied to perf/core.

- Arnaldo
