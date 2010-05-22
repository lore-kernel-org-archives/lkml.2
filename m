Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0EVIac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:30:32 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:48855 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab0EVIa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:30:27 -0400
Date: Sat, 22 May 2010 09:30:21 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] interrupt.h: fix fatal kernel-doc error
Message-ID: <20100522093021.34225ad4@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20100521090301.716af51c.randy.dunlap@oracle.com>
References: <20100521090301.716af51c.randy.dunlap@oracle.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 77.206.155.245
X-SA-Exim-Rcpt-To: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 09:03:01 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc fatal error:
> /** beginning a non-kernel-doc comment block:
> (That alone does not kill kernel-doc, but the 'enum' was
> totally confusing to it.)
> 
> Error(/lnx/src/TMP/linux-2.6.34-git6//include/linux/interrupt.h:88): cannot understand prototype: 'enum '
> make[2]: *** [Documentation/DocBook/genericirq.xml] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Marc Zyngier <maz@misterjones.org>

	M.
-- 
I'm the slime oozin' out from your TV set...
