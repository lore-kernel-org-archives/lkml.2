Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab1J0Vou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:44:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:56281 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1J0Vot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:44:49 -0400
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Avi Miller <avi.miller@oracle.com>
X-Priority: 3
In-Reply-To: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
Date: Fri, 28 Oct 2011 08:44:17 +1100
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4F63081B-84E7-4FF8-8920-5AF4B73895D1@oracle.com>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
X-Mailer: Apple Mail (2.1251.1)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4EA9D0C6.0074,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus et al,

If further support is required:

On 28/10/2011, at 5:52 AM, Dan Magenheimer wrote:

> Linux kernel distros incorporating frontswap:
> - Oracle UEK 2.6.39 Beta:

I have been testing this kernel for a while now as well and is performing well. I have tested Xen HVM, HVPVM and PVM guests all with tmem enabled. Automated testing is scheduled to go into our test farm (that runs ~80,000 hours of QA of testing of Oracle products on Oracle Linux per day) soon.

> - OracleVM since 2.2 (2009)

Likewise. We are planning to incorporate Transcendent Memory support into future Oracle VM 3.0 releases as support functionality, i.e. that this will be enabled on a per-server/per-guest basis so that guests are capable of reducing memory footprint. We see this as a critical feature to compete with other hypervisor's memory sharing/de-duplication functionality.

Thanks,
Avi

---
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

