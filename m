Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1CATK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:10:26 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44483 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1CATKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EHgPOUhae6dP2qV55P+3eDYf8U0ZcgcQptcKHSqfGZVDTrKBXnMxtBWrDXRkzf40Xj
         BMqlSiMJgzoKiSN18LYzwNNMgbctSDFUzFR39vfnFIwGTI937rO8i61pgfogf6aEWPk3
         jNdU3WjrQtSEt0RmsriUVqw1YvDAnngx1L5/U=
MIME-Version: 1.0
In-Reply-To: <20110301104924.071044ef.randy.dunlap@oracle.com>
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
	<20110301104924.071044ef.randy.dunlap@oracle.com>
Date: Tue, 1 Mar 2011 21:10:23 +0200
X-Google-Sender-Auth: np9dsSrBKEx67pmyWZbPK_N9g6g
Message-ID: <AANLkTimX0zvBEMxedXnhXiaxwEKHmm_Tu6fiZQkahZrC@mail.gmail.com>
Subject: Re: linux-next: Tree for March 1 (staging/winbond)
From: Pekka Enberg <penberg@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 8:49 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Tue, 1 Mar 2011 18:11:19 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20110228:
>
>
> commit ddee7e28e7d5e4ba2b8537c6a59b035745c250bb
> Author: Pekka Enberg <penberg@kernel.org>
> Date:   Sun Nov 28 23:00:01 2010 +0200
>    Staging: w35und: Remove empty sysdef.h header
>
>
> This header should not have been empty, since in
>
> commit 412dc7f368bf10a8049a8a4c41abbfd0108742e7
> Author: Randy Dunlap <randy.dunlap@oracle.com>
> Date:   Fri Nov 19 09:30:18 2010 -0800
>    staging: fix winbond build, needs delay.h
>
> I added delay.h to it.  And now we have the same build
> errors that I fixed last November:
>
> drivers/staging/winbond/phy_calibration.c:986: error: implicit declaration of function 'msleep'
> drivers/staging/winbond/phy_calibration.c:1555: error: implicit declaration of function 'udelay'
> drivers/staging/winbond/reg.c:893: error: implicit declaration of function 'msleep'
> drivers/staging/winbond/reg.c:1169: error: implicit declaration of function 'udelay'

Strange. I didn't see the problem. We should add delay.h to
phy_calibration.c and reg.c instead. Care to make a patch?
