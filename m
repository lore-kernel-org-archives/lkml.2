Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab0E0SIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:08:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53344 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab0E0SIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hO4dOE6hMZhiyP9JXfcMpup/MRhmkjfKPHWEbz9FBK8HFxDuRClz0cJQGFUrLJvT57
         cEbAboF2YcJr7w89ScQgR63tG+69G6sqS7kRfLcn0Arck3Scn2f9ez+Owk7oPgC2ZGFp
         5HeHpgblBJaJsPs5AdokjBW+80qXySjPlRKlg=
MIME-Version: 1.0
Date: Thu, 27 May 2010 12:08:48 -0600
Message-ID: <AANLkTil6GGSoc8TpzRacr1LZBZS3ee3H1ejYDSqfdul4@mail.gmail.com>
Subject: Linux 2.6.34 causes system lockup on Compaq Presario 2200 Laptop
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34 causes a hard system lockup when the screen blanking activates
for more than 10 minutes with low battery power.  Also misreports
battery level as "battery broken at 14%" when the battery is fully
charged.  Does not occur with 2.6.28 but 2.6.33 also seems to do it as
well.  software debugging tools useless as the keyboard does not
respond.

Jeff
