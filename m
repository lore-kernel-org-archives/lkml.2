Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934450Ab0EDW3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:29:18 -0400
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:57477 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934099Ab0EDW3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:29:16 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2010 18:29:16 EDT
X-MXL-Hash: 4be09fbc34cfcec8-367f3ccb35ca55a0ed44e0955f08a541f2322df6
X-MXL-Hash: 4be09cb7053b5602-60274278d416e91e6bed9bf908661b0bdbcd1453
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 4 May 2010 17:15:36 -0500
Subject: RE: [Bug #15729] BUG: physmap modprobe & rmmod
Thread-Topic: [Bug #15729] BUG: physmap modprobe & rmmod
Thread-Index: Acrr1ieoyfmtuWQFQfyE5zJLukCkvAAAPbKg
Message-ID: <0D753D10438DA54287A00B0270842697636EB83FB2@AUSP01VMBX24.collaborationhost.net>
References: <JzEGxUyyQHG.A.ZtH.YHJ4LB@chimera>
 <8VO9AsMlpMD.A.-m.4IJ4LB@chimera>
In-Reply-To: <8VO9AsMlpMD.A.-m.4IJ4LB@chimera>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010050401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=CyGLniF1gukA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=VwQbUJbxAAAA:8 a=yPC]
X-AnalysisOut: [of4ZbAAAA:8 a=gu6fZOg2AAAA:8 a=i00gxMtYAAAA:8 a=hA7INtIzO7]
X-AnalysisOut: [jTU5J-gFwA:9 a=d3tykvge_g_UqhwsNT6mIsj_ypgA:4 a=QEXdDO2ut3]
X-AnalysisOut: [YA:10 a=7DSvI1NPTFQA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o44MTXmE027471

On Tuesday, May 04, 2010 2:21 PM, Rafael J. Wysocki wrote:
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
> Date		: 2010-04-02 20:40 (33 days old)
> Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
> References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
> Handled-By	: Hartley Sweeten <hsweeten@visionengravers.com>
> Patch		: https://patchwork.kernel.org/patch/90497/

This patch is not yet in Linus' tree, it is in linux-next.  David?

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
