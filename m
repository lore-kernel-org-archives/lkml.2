Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608Ab2EJVjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:39:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45408 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761597Ab2EJVji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:39:38 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19emapK7TJenc5F6OWMdxa5Rm64tok10B5LnzCRk+
	4vvzjObdkjt41h
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH] video/sis: Annotate SiS_DRAMType as __devinitconst
Date: Thu, 10 May 2012 23:39:08 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.3; KDE/4.7.4; x86_64; ; )
Cc: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4FAB0986.6090006@gmx.de>
In-Reply-To: <4FAB0986.6090006@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205102339.09295.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 10 Mai 2012, 02:19:18 schrieb Florian Tobias Schandinat:
> Good that you did this one, it was more to be done than I expected. I
> ignored the checkpatch errors as you didn't introduce them but maybe it
> wouldn't be a bad idea to fix things up if you touch them. Applied.

Oh sorry, usually I do checkpatch, but I missed it on this one somehow.
If you want, I can do a checkpatch cleanup for the whole sis driver as 
compensation ;)

Thanks,
Peter
