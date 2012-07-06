Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2GFUTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:19:15 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1674 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab2GFUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:19:14 -0400
Message-ID: <1341605949.22584.6.camel@x61.thuisdomein>
Subject: Re: [PATCH] CONFIG_CC_STACKPROTECTOR is no longer experimental
From: Paul Bolle <pebolle@tiscali.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jean Delvare <jdelvare@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Date: Fri, 06 Jul 2012 22:19:09 +0200
In-Reply-To: <4FF72733.8000007@linux.intel.com>
References: <1341583705.4655.18.camel@amber.site>
	  <4FF71F1C.4040608@xenotime.net> <1341597439.4655.23.camel@amber.site>
	 <4FF72733.8000007@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jul 2012 20:19:10.0697 (UTC) FILETIME=[9A714D90:01CD5BB4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 10:58 -0700, Arjan van de Ven wrote:
> I rather just retire the whole concept of "Experimental".
> 
> it's really utterly meaningless in practice anyway.

See Russell King's quick survey in https://lkml.org/lkml/2012/1/18/397 :
almost all defconfigs had CONFIG_EXPERIMENTAL enabled. I didn't recheck
since I'm sure little has changed. That macro and the related Kconfig
symbol seem indeed meaningless.


Paul Bolle

