Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0GARoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:44:19 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:40412 "HELO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752998Ab0GARoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:44:18 -0400
From: Rupjyoti Sarmah <rsarmah@apm.com>
References: <201006241327.o5ODRY6m032299@amcc.com> <20100630115808.2D9241524EC@gemini.denx.de> 
	<3b928476b2fffdcf0694e5436e8a482f@mail.gmail.com> <20100630184728.C02D014EBF9@gemini.denx.de> 
	<4C2B9831.9020801@pobox.com> <20100630200325.GD7756@zod.rchland.ibm.com> 
	<20100630225516.8F9D3152442@gemini.denx.de>
In-Reply-To: <20100630225516.8F9D3152442@gemini.denx.de>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcsYp1G6fI1Y4xp/S2yJLSTzi1VYZgAm51Rw
Date: Thu, 1 Jul 2010 23:14:14 +0530
Message-ID: <4645a5c409da26358f3102276bbccf72@mail.gmail.com>
Subject: RE: [PATCH v1]460EX on-chip SATA driver<resubmisison>
To: Wolfgang Denk <wd@denx.de>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, sr@denx.de, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

The Synopsis design ware core is task file orientated so the driver would
still need CONFIG_ATA_SFF.
I would be fixing the Kconfig file to make it dependent on the
CONFIG_ATA_SFF.

Regards,
Rup



-----Original Message-----
From: Wolfgang Denk [mailto:wd@denx.de]
Sent: Thursday, July 01, 2010 4:25 AM
To: Josh Boyer
Cc: Jeff Garzik; linux-ide@vger.kernel.org; sr@denx.de; Rupjyoti Sarmah;
linux-kernel@vger.kernel.org; linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v1]460EX on-chip SATA driver<resubmisison>

Dear Josh Boyer,

In message <20100630200325.GD7756@zod.rchland.ibm.com> you wrote:
>
> The driver doesn't depend on CONFIG_ATA_SFF in it's Kconfig file, but
seems to
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
