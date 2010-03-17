Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0CQMPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:15:08 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:53507 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab0CQMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:15:05 -0400
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 08:15:05 EDT
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohavlCkce+Ub5QXMSOpHp3LrAMgFm4S5s=
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> < resubmission : 01>
Date: Wed, 17 Mar 2010 13:03:06 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.32.8-sr; KDE/4.4.1; i686; ; )
Cc: "Rupjyoti Sarmah" <rsarmah@amcc.com>, linux-ide@vger.kernel.org,
       "Jeff Garzik" <jgarzik@pobox.com>,
       Rupjyoti Sarmah <rupjyoti.sarmah@gmail.com>, linuxppc-dev@ozlabs.org,
       Rupjyoti Sarmah <rupjyoti.sarmah@appliedmicro.com>,
       linux-kernel@vger.kernel.org
References: <1268646854-27387-1-git-send-email-rsarmah@appliedmicro.com> <AC311A8E81420D4EBC1F26E6479848FE065B7F30@SDCEXCHANGE01.ad.amcc.com>
In-Reply-To: <AC311A8E81420D4EBC1F26E6479848FE065B7F30@SDCEXCHANGE01.ad.amcc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171303.06258.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rup,

On Wednesday 17 March 2010 05:23:16 Rupjyoti Sarmah wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro
> processor 460EX.

Apart from the other comments, did you take a look at the latest version of 
this driver in our linux-2.6-denx repository? We did some work on this driver 
for a new Canyonlands release last year. It's hard to check this for me now, 
with this line wrapped patch (the drivers diverged somewhat). So either check 
for yourself, or send a new, not line-wrapped, patch version so that I can 
better check myself.

BTW: It would be nice if you would add me to Cc on DWC-SATA related patches, 
since I've been involved in the development at some time.

Thanks.

Cheers,
Stefan

--
DENX Software Engineering GmbH,      MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich,  Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-0 Fax: (+49)-8142-66989-80 Email: office@denx.de
