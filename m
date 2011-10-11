Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1JKONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:13:52 -0400
Received: from smtp-cpk.frontbridge.com ([204.231.192.41]:31147 "EHLO
	WA2EHSNDR001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752151Ab1JKONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:13:51 -0400
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: -6
X-BigFish: VS-6(z21eNz98dKzz1202h1082kzzz2dh87h2a8h668h839h944h41h42h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:94.101.220.16;KIP:(null);UIP:(null);IPVD:NLI;H:nzt0015e.dknz.nzcorp.net;RD:none;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 11 Oct 2011 16:13:38 +0200
From: Anders Ossowicki <aowi@novozymes.com>
To: Christoph Hellwig <hch@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <aradford@gmail.com>, <xfs@oss.sgi.com>
Subject: Re: 2.6.38.8 kernel bug in XFS or megaraid driver with heavy I/O load
Message-ID: <20111011141338.GA11808@otto.nzcorp.net>
Reply-To: <aowi@novozymes.com>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, aradford@gmail.com, xfs@oss.sgi.com
References: <20111011091757.GA32589@otto.nzcorp.net>
 <20111011133448.GA10692@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111011133448.GA10692@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SMTP-Mail-From: aowi@otto.nzcorp.net
X-OriginatorOrg: novozymes.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 03:34:48PM +0200, Christoph Hellwig wrote:
> This is core VM code, and operates purely on on-stack variables except
> for the page cache radix tree nodes / pages.  So this either could be a
> core VM bug that no one has noticed yet, or memory corruption.  Can you
> run memtest86 on the box?

Unfortunately not, as it is a production server. Pulling it out to memtest 256G
properly would take too long. But it seems unlikely to me that it should be
memory corruption. The machine has been running with the same (ecc) memory for
more than a year and neither the service processor nor the kernel (according to
dmesg) has caught anything before this. It would be a rare (though I admit not
impossible) coincidence if we got catastrophic, undetected memory corruption a
week after attaching a new raid controller with a new disk array.
-- 
Anders Ossowicki

