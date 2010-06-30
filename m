Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab0F3SXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:23:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54513 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0F3SXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:23:31 -0400
X-Auth-Info: LiLm2ItddMr6RrCEFas0rbgLxDvUX/0vin72jXJlI10=
To: Rupjyoti Sarmah <rsarmah@apm.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, linuxppc-dev@ozlabs.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH v1]460EX on-chip SATA driver<resubmisison>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com>
References: <201006241327.o5ODRY6m032299@amcc.com> <20100630115808.2D9241524EC@gemini.denx.de> <3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com>
Comments: In-reply-to Rupjyoti Sarmah <rsarmah@apm.com>
   message dated "Wed, 30 Jun 2010 18:14:47 +0530."
Date: Wed, 30 Jun 2010 20:23:26 +0200
Message-Id: <20100630182326.3A48B1524EC@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rupjyoti Sarmah,

In message <3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com> you wrote:
> 
> I took the mainline kernel v2.6.35-rc3 and downloaded using the git
> download link.
> I created the patch on 6/24/2010 after doing a git pull.
> 
> With the kernel tree on 6/24/2010 the driver compiled. I also tested the
> functionality on the SATA drive & it worked.

v2.6.35-rc3 was released on June 11, 13 days before 6/24/2010.

Can you please give the exact git commit ID so I can try reproducing
this?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
There comes to all races an ultimate crisis which  you  have  yet  to
face  ....  One  day  our  minds became so powerful we dared think of
ourselves as gods.
	-- Sargon, "Return to Tomorrow", stardate 4768.3
