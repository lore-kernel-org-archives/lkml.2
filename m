Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1JHWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 18:09:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50825 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1JHWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 18:09:27 -0400
Date: Sun, 9 Oct 2011 01:05:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: JAke Burton <jake5991@live.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, fmhess@users.sourceforge.net,
        abbotti@mev.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: fix brace coding and whitespace
 issue in ni_atmio.c
Message-ID: <20111008215930.GM18470@longonot.mountain>
References: <BLU0-SMTP9072E77C5346BC9ADCE223A2FF0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP9072E77C5346BC9ADCE223A2FF0@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E90CA08.002E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nah.  For this kind of thing you need to redo the first one, not
just write another patch on top of it.  The v2 patch should have a
subject with [patch v2] blah blah blah.  After the Signed-off-by line
put three dashes "---" and then the changes between v1 and v2.

Signed-off-by:  you
---
v2:  whitespace changes for Joe Perches.

Joe should be added to the CC list.  Hopefully it should be sent in
the same thread as a response to Joe's email.  Use the In-Reply-To
header.

Also the "};" on the first hunk should be moved down a line as well.

And the subject and the commit message on the first patch were
mangled.  There wasn't a blank line after the Subject and before the
changelog.  It need another blank line in front of the Signed-off-by
line and this patch doesn't have a Signed-off-by line.  (These things
matter because the process is scripted).

If you want you can leave linux-kernel off the CC list.  They don't
care about whitespace patches to staging.

regards,
dan carpenter

