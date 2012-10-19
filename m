Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2JSV2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:28:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51009 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab2JSV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:28:00 -0400
Date: Fri, 19 Oct 2012 17:28:45 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        vincent.weaver@maine.edu
Subject: [PATCH 0/3] perf_event: improvements to p6 PMU driver
Message-ID: <alpine.DEB.2.02.1210191722430.14552@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The following patches include some fixes for the p6 PMU driver.
I noticed these when working on the KNC driver which is roughly based
on the p6 driver.

patch1: Fixes a wrong event constraint
patch2: Expands the number of generic events supported by p6
patch3: Cleans up p6_pmu_enable_event() and p6_pmu_disable_event()
        Changes around the 2.6.33 to 2.6.34 transition left some
        confusing dead code around that was no longer necessary.

I've tested all of these on a Pentium II machine I brought out of 
retirement.

Vince Weaver
vincent.weaver@maine.edu
-- 
char x,_,*O="yyyyl1f41mm65mm5OU5m5_55m5555mmGUml1ED1ooG_ol\\lDClN:eml9niiobTQO"
"m8dlYoo=HUmmaNEnCDY[l1G@7oo975l1>UImmSG3m5`@Om5<OGm5__5mm4S_l1DTiyyyy";void X(
int x){while(x>-1)printf("\033[4%dm  ",x%2*7),x-=2;}int main(){while(*O){for(x=
30;x--;)_=*O-48,X(_>>6?59:(_>>x%6)&1),x*=_<64,O+=!(x%6);X(5),X(0),puts("");}}
