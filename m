Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1GYDTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 23:19:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37896 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1GYDTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 23:19:45 -0400
MIME-Version: 1.0
Message-ID: <a5d17beb-847b-48c0-82d7-cfabe419e7f9@default>
Date: Sun, 24 Jul 2011 20:19:24 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: RE: [PATCH 1/2] staging: fix zcache building
References: <1311556452-1859-1-git-send-email-cascardo@holoscopio.com>
In-Reply-To: <1311556452-1859-1-git-send-email-cascardo@holoscopio.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E2CE0CB.0044:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thadeu Lima de Souza Cascardo [mailto:cascardo@holoscopio.com]
> Sent: Sunday, July 24, 2011 7:14 PM
> To: Nitin Gupta
> Cc: Dan Magenheimer; Greg Kroah-Hartman; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org;
> Thadeu Lima de Souza Cascardo
> Subject: [PATCH 1/2] staging: fix zcache building
> 
> zcache is only building tmem.c and not building zcache.c. To keep the
> module name, zcache.c must be renamed if symbols from tmem.c are to
> remain unexported.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>


Greg --

Since a newer version of zcache.c is already in staging-next (and
hopefully soon in staging-for-linus for the 3.1 window), this
patch, which simply replaces the (older) zcache.c with identical
code with a different filename, would not apply cleanly.  Could
you advise on the best way to ensure both the newer version
and the file rename are applied... perhaps the rename must be
done manually in your git tree(s)?

Though I'm not certain of the process steps, please consider the
rename, the one liner Makefile change for the rename, and the GPL
module license addition (in patch 2/2)...

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Thanks,
Dan
