Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0CYRQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:16:16 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:33474 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0CYRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:16:15 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 13:16:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YEKG3dSn67x0nSRgdGD8GC/l+MwG+d/IjYL+Vogs0E+02U50/t3rO+p0kuoqKCbs3T
         bAcgyvCJA3paeOn49daPVhA/JE/HGJSZHN009YVIQApUgbd5XuZh8oXUQWxVcYa9HTeF
         A71C/NvJ8TiEuLvDbNRkzDWr/ap+Fe/ehj/9A=
MIME-Version: 1.0
Date: Thu, 25 Mar 2010 18:11:09 +0100
Message-ID: <2d460de71003251011y2d8d1931u683b396f40df4ed1@mail.gmail.com>
Subject: Question about e06e7c615877026544ad7f8b309d1a3706410383 -- [IPV4]: 
	The scheduled removal of multipath cached routing support.
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: davem@sunset.davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was wondering what the rationale for commit
e06e7c615877026544ad7f8b309d1a3706410383 is. We upgraded our custom
image to 2.6.33 recently and found those options to be missing.


Thanks,
Richard Hartmann
