Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab2EFGhC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 02:37:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25853 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2EFGhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 02:37:00 -0400
Date: Sun, 6 May 2012 09:38:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com,
        andor.daam@googlemail.com, grabner@icg.tugraz.at, jj@chaosbits.net,
        thomas@m3y3r.de
Subject: Re: [PATCH 2/8] drivers/staging/line6/pod.c: Change strict_strtoul
 to kstrtoul
Message-ID: <20120506063839.GI22134@mwanda>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
 <1336228312-5379-3-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336228312-5379-3-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 04:31:46PM +0200, Johannes Thumshirn wrote:
> Changed strict_strtoul() call to kstrtoul to make checkpatch.pl happy
> 

These as well should be reconsidered.  Mostly they should be u8 I
think.  The problem is that there wasn't a strict_strtou8() so the
update is no a one to one translation.

regards,
dan carpenter

