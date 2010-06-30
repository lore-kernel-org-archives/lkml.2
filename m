Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0F3WzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:55:24 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35762 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0F3WzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:55:19 -0400
X-Auth-Info: XE0+hH3jMVAyrOIWREdOZcLsAq2btm4sMLrgByw9Q98=
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, sr@denx.de,
       Rupjyoti Sarmah <rsarmah@apm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH v1]460EX on-chip SATA driver<resubmisison>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <20100630200325.GD7756@zod.rchland.ibm.com>
References: <201006241327.o5ODRY6m032299@amcc.com> <20100630115808.2D9241524EC@gemini.denx.de> <3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com> <20100630184728.C02D014EBF9@gemini.denx.de> <4C2B9831.9020801@pobox.com> <20100630200325.GD7756@zod.rchland.ibm.com>
Comments: In-reply-to Josh Boyer <jwboyer@linux.vnet.ibm.com>
   message dated "Wed, 30 Jun 2010 16:03:25 -0400."
Date: Thu, 01 Jul 2010 00:55:16 +0200
Message-Id: <20100630225516.8F9D3152442@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Josh Boyer,

In message <20100630200325.GD7756@zod.rchland.ibm.com> you wrote:
>
> The driver doesn't depend on CONFIG_ATA_SFF in it's Kconfig file, but seems to
> require it at build time.  Isn't that something that needs fixing in the
> driver?

Right.  Next question is if this is really needed for this driver. 

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Copy from one, it's plagiarism; copy from two, it's research.
