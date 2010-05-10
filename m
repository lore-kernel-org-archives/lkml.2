Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab0EJQZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:25:25 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:36201 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab0EJQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:25:19 -0400
X-MXL-Hash: 4be8336f3c502df1-b81728ee544c0564e5edcfda8caf3fc4635fee73
X-MXL-Hash: 4be8336a60e08549-925472da0ca94bfb72b34d8693dc69783d3e1d51
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 10 May 2010 11:23:08 -0500
Subject: RE: [Bug #15729] BUG: physmap modprobe & rmmod
Thread-Topic: [Bug #15729] BUG: physmap modprobe & rmmod
Thread-Index: Acrvw5oe0Dnt0lJ3SsSeyB+ed1Sm/QAmU/Ig
Message-ID: <0D753D10438DA54287A00B0270842697636EDF56E5@AUSP01VMBX24.collaborationhost.net>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
 <HqroMXsT-CJ.A.YTF.R-y5LB@chimera>
In-Reply-To: <HqroMXsT-CJ.A.YTF.R-y5LB@chimera>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=CyGLniF1gukA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=VwQbUJbxAAAA:8 a=yPC]
X-AnalysisOut: [of4ZbAAAA:8 a=gu6fZOg2AAAA:8 a=i00gxMtYAAAA:8 a=hA7INtIzO7]
X-AnalysisOut: [jTU5J-gFwA:9 a=Wl8EM3PbYK-GUTPfTvBYF1muGi8A:4 a=QEXdDO2ut3]
X-AnalysisOut: [YA:10 a=7DSvI1NPTFQA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4AGQmaS013900

On Sunday, May 09, 2010 2:18 PM, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
> Subject		: BUG: physmap modprobe & rmmod
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2010-04-02 20:40 (38 days old)
> Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
> References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
> Handled-By	: Hartley Sweeten <hsweeten@visionengravers.com>
> Patch		: https://patchwork.kernel.org/patch/90497/

Please keep listed.  This patch is still waiting to be merged via the -mtd
tree.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
