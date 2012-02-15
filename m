Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2BOP5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:57:54 -0500
Received: from mail.southpole.se ([193.12.106.18]:51810 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2BOP5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:57:51 -0500
X-Greylist: delayed 1014 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 10:57:50 EST
Message-ID: <1329321471.2670.93.camel@crucifix>
Subject: Re: [PATCH 21/40] OpenRISC: Don't reimplement force_sigsegv()
From: Jonas Bonn <jonas@southpole.se>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net
Date: Wed, 15 Feb 2012 16:57:51 +0100
In-Reply-To: <1329320945.3675.149.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
	 <1329219673-28711-22-git-send-email-matt@console-pimps.org>
	 <1329320456.2670.86.camel@crucifix>
	 <1329320945.3675.149.camel@mfleming-mobl1.ger.corp.intel.com>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 21468-00523
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-02-15 at 15:49 +0000, Matt Fleming wrote:
> On Wed, 2012-02-15 at 16:40 +0100, Jonas Bonn wrote:
> > Acked-by: Jonas Bonn <jonas@southpole.se>
> > 
> > ...for OpenRISC, all 4 patches (20-23 in this series).
> > 
> > Should I take these in the OpenRISC tree or how did you want to do?
> 
> Whatever you prefer. Feel free to take them through the OpenRISC tree.

OK, great, I'll pull them into the OpenRISC tree for 3.4.

Thanks,
Jonas

