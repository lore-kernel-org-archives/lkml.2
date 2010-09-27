Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab0I0P4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:56:18 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:22714 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932849Ab0I0P4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:56:14 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: RFSXUzwVM1nOPyMrLjbHT9RDBGsJMGlF2NIESCLZL8vd3m_
 4Cvlvv_4rO7cjEikIeGizDu6cLPG0EeMI_YohIL3UpLkO3ko7jrpBvrz3Z4t
 FMgo9CYzsBXzz1odjnXRDGCZHuFge8_xYCM4Pqmgu2n7o.5eQ0G.SwQ4tF.J
 qYBmn9d_i8s5T34iYrWMm6tbA2hE8Lnwv_Y5LRbMieudTWEQEa2ElrjjbRlO
 sJsks1YVQFo8B9Z3oNygvHkKWE0M-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 27 Sep 2010 10:56:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
In-Reply-To: <20100924150246.0e6064b6@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1009271054320.9258@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at> <20100923213654.0c64b047@lxorguk.ukuu.org.uk> <20100924131407.GA3113@riccoc20.at.omicron.at> <20100924150246.0e6064b6@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Sep 2010, Alan Cox wrote:

> Whether you add new syscalls or do the fd passing using flags and hide
> the ugly bits in glibc is another question.

Use device specific ioctls instead of syscalls?

