Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0CZV7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:59:49 -0400
Received: from c60.cesmail.net ([216.154.195.49]:48348 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab0CZV7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:59:48 -0400
Subject: Re: [git patches] libata fixes
From: Pavel Roskin <proski@gnu.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269634672.8534.2.camel@mj>
References: <20100323134226.GA14752@havoc.gtf.org>
	 <1269367619.13592.12.camel@mj>  <4BAB8D76.5040104@kernel.org>
	 <1269634672.8534.2.camel@mj>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 17:59:46 -0400
Message-Id: <1269640786.8534.67.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 16:17 -0400, Pavel Roskin wrote:

> It looks like I'm still getting "clearing spurious IRQ".

Sorry, my mistake.  I reverted the patch by accident.  Please ignore.

-- 
Regards,
Pavel Roskin
