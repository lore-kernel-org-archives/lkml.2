Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1GVSDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:03:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37020
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368Ab1GVSDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:03:19 -0400
Date: Fri, 22 Jul 2011 14:03:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Tejun Heo <tj@kernel.org>,
        Vladimir Zapolskiy <vzapolskiy@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ptrace changes for v3.1
Message-ID: <20110722180312.GA744@infradead.org>
References: <20110722173237.GA16787@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722173237.GA16787@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 07:32:37PM +0200, Oleg Nesterov wrote:
> 	- f701e5b7 "connector: add an event for monitoring process tracers" is
> 	  a bit off-topic, it was routed via ptrace branch because it textually
> 	  depends on the changes in tracehook/ptrace_attach code.

Please do not actually add anything to the connector code.  It's a
horrible interface and users should migrate away from it.

