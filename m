Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2JBRHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:07:49 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2453 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570Ab2JBRHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:07:47 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Subject: Re: tg3 driver upgrade (Linux 2.6.32 -> 3.2) breaks IBM
 Bladecenter SoL
From: "Michael Chan" <mchan@broadcom.com>
To: "Ferenc Wagner" <wferi@niif.hu>
cc: netdev@vger.kernel.org, "Matt Carlson" <mcarlson@broadcom.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
In-Reply-To: <87haqcddks.fsf@lant.ki.iif.hu>
References: <87txuhho5z.fsf@lant.ki.iif.hu>
 <1349083982.5420.16.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <87a9w5dqle.fsf@lant.ki.iif.hu>
 <1349190185.5420.21.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
 <87haqcddks.fsf@lant.ki.iif.hu>
Date: Tue, 2 Oct 2012 10:06:47 -0700
Message-ID: <1349197607.5420.25.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
X-WSS-ID: 7C75C17D3OW1076096-01-01
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 18:49 +0200, Ferenc Wagner wrote:
> Going into the opposite direction: I found that Linux 3.6 does not
> permanently break the SoL console on upping eth0!  I'll try to find
> the
> commit which (sort of) fixed it.

These are the likely fixes:
> 
commit cf9ecf4b631f649a964fa611f1a5e8874f2a76db 
Author: Matt Carlson <mcarlson@broadcom.com>
Date: Mon Nov 28 09:41:03 2011 +0000

tg3: Fix TSO CAP for 5704 devs w / ASF enabled

commit 7196cd6c3d4863000ef88b09f34d6dd75610ec3e
Author: Matt Carlson <mcarlson@broadcom.com>
Date: Thu May 19 16:02:44 2011 +0000

tg3: Add braces around 5906 workaround.



