Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0H3McV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:32:21 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47276 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755414Ab0H3McU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:32:20 -0400
Date: Mon, 30 Aug 2010 08:32:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.226 for kernel 2.6.35.4
Message-ID: <20100830123215.GA30031@Krystal>
References: <20100830121335.GA17882@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830121335.GA17882@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:31:28 up 219 days, 15:08,  4 users,  load average: 0.10, 0.08,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And LTTng 0.226 is a cleanup version removing the psrwlock patches, which were
unused.

Thanks,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Hi,
> 
> I just rebased LTTng on top of 2.6.35.4, and pulled v11 of "generic alignment"
> into the tree.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
