Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2APV2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 16:28:24 -0500
Received: from snt0-omc1-s22.snt0.hotmail.com ([65.55.90.33]:26250 "EHLO
	snt0-omc1-s22.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756162Ab2APV2X convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 16:28:23 -0500
Message-ID: <SNT144-W1F7026BA077AA0D46B5E3DF830@phx.gbl>
X-Originating-IP: [173.161.69.124]
From: Jason Dravet <dravet@hotmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] clarify WARNING: at fs/sysfs/dir.c:481 sysfs_add
Date: Mon, 16 Jan 2012 15:28:22 -0600
Importance: Normal
In-Reply-To: <SNT144-W477468478D64073A33B390DF830@phx.gbl>
References: <SNT144-W1DC10F59BB90518BD3FBFDF820@phx.gbl>,<20120115153032.GA716@redhat.com>,<SNT144-W477468478D64073A33B390DF830@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jan 2012 21:28:22.0334 (UTC) FILETIME=[C5F5D5E0:01CCD495]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  > This patch makes it clear that the problem is in the BIOS of 
the computer and not the kernel.  This patch applies to kernel 3.2.1.
>  >  
>  > --- dir.orig    2012-01-14 18:58:20.026745884 -0600
>  > +++ dir.c    2012-01-14 19:52:33.011444581 -0600
>  > @@ -479,6 +479,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt
>  >               (path == NULL) ? sd->s_name :
>  >               strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
>  >                      sd->s_name));
>  > +        WARN(1, KERN_WARNING
>  > +             "Your BIOS is broken.  Please contact your computer manufacturer.");
>  >          kfree(path);
>  >      }
>  
> That certainly isn't always the case. Incorrectly written drivers
> have also taken this codepath before now.
> 
> 	Dave

Then how do you tell when the problem is the BIOS or a driver?
Jason 		 	   		  