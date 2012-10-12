Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab2JLPOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:14:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51416 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028Ab2JLPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:14:16 -0400
Date: Fri, 12 Oct 2012 17:14:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iant@google.com" <iant@google.com>
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging instruction sequence and saving register
Message-ID: <20121012151410.GB16230@one.firstfloor.org>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com> <m2bog9t9cr.fsf@firstfloor.org> <B2310DA9850C8743AA7AA0055500E90F0FD709C4@SHSMSX102.ccr.corp.intel.com> <20121012133554.GA16230@one.firstfloor.org> <B2310DA9850C8743AA7AA0055500E90F0FD70B53@SHSMSX102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2310DA9850C8743AA7AA0055500E90F0FD70B53@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 02:54:54PM +0000, Ma, Ling wrote:
> > If you can't test the CPUs who run this code I think it's safer if you
> > add a new variant for Atom, not change the existing well tested code.
> > Otherwise you risk performance regressions on these older CPUs.
> 
> I found one older machine, and tested the code on it, the results between them are almost the same as below(attached cpu info).

Was that a P4 (family 15)? 

Those were the main users. There were a few others, but they are obscure
(early steppings of K8) 

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
