Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1HTNJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 09:09:37 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:51113 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751697Ab1HTNJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 09:09:34 -0400
Date: Sat, 20 Aug 2011 14:09:19 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
        "Steven J. Hill" <sjhill@realitydiluted.com>,
        Chris Dearman <chris@mips.com>
Subject: Re: [RFC patch] MIPS: select correct tc
Message-ID: <20110820130918.GA5097@linux-mips.org>
References: <CAJd=RBA9ihp94TtjkWbAVo1Y_2+Vp1VskJWVahN85biCEAYWtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBA9ihp94TtjkWbAVo1Y_2+Vp1VskJWVahN85biCEAYWtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:38:31PM +0800, Hillf Danton wrote:

> If we could find tc on the tc list for @index, the found tc should be returned.

This bug has been in the VPE code since 2009 and it pretty much proofs
that nobody is using this crap.

I've applied your patch but your finding of this bug which is around since
about two years pretty much proofs that nobody is using this code, so it
can be removed.  It's been fugly since day one..

Thanks,

  Ralf
