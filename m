Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1BARdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:33:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52586 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab1BARdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:33:53 -0500
Date: Tue, 1 Feb 2011 09:32:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for February 1 (sound/soc)
Message-Id: <20110201093256.f5ff0252.randy.dunlap@oracle.com>
In-Reply-To: <20110201153403.b3a251a3.sfr@canb.auug.org.au>
References: <20110201153403.b3a251a3.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 15:34:03 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110131:


When CONFIG_PM_SLEEP is not enabled:

sound/soc/soc-core.c:1785: error: 'soc_resume_deferred' undeclared (first use in this function)

That function call is surrounded by CONFIG_PM but the function itself is
surrounded by CONFIG_PM_SLEEP.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
