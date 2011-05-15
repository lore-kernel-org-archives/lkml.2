Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1EOTMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 15:12:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36932 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1EOTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 15:12:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=jXCQ2PMTb0apatOT5vHG8Jl1ilOMy0lPKrGrqh6Gz4SSDCrUVmTN+42TEF6VZHs/aF
         kJjIdP/fVogn1fRs2oLwzxSk34lTK0ut3BoFdPKIu3cMk1VCPrG0g886WYAcyPk6gw/W
         IUvhF7hrQ4HUWAC2BywplJvvbSdqejxUcFt9g=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #34002] [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer and X Window
Date: Sun, 15 May 2011 21:12:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc7; KDE/4.4.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>
References: <So1vU2GC7XM.A.5wB.44vzNB@chimera> <HA8urZ3ZRcP.A.cZC.h5vzNB@chimera>
In-Reply-To: <HA8urZ3ZRcP.A.cZC.h5vzNB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105152112.45069.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 15 maja 2011 o 00:30:07 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.38.  Please verify if it still should be listed and let the
> tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=34002
> Subject		: [REGRESSION] [2.6.39-rc3] Wrong resolution in framebuffer 
and X
> Window Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2011-04-17 16:04 (28 days old)
> Message-ID	: <201104171804.04664.maciej.rutecki@gmail.com>
> References	: http://marc.info/?l=linux-fbdev&m=130305625114863&w=2


Still present in -rc7

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
