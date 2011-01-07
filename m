Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1AGWVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:21:15 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:40532 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753862Ab1AGWVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:21:14 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, konrad@darnok.org
In-Reply-To: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 07 Jan 2011 22:21:00 +0000
Message-ID: <1294438860.12280.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.7
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [RFC PATCH v2] Utilize the PCI API in the TTM framework.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=4eYIZ_Hv1GIA:10 a=8nJEP1OIZ-IA:10 a=D19gQVrFAAAA:8 a=tHz9FfFoAAAA:8 a=xNf9USuDAAAA:8 a=F6UfI3xHLa2ZW7SZ3QUA:9 a=QeVSQVoKOEKCEWt0X9jeRYcJoF4A:4 a=wPNLvfGTeEIA:10 a=6O0IECtVFhoA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 12:11 -0500, Konrad Rzeszutek Wilk wrote: 
> Attached is a set of patches that make it possible for drivers using TTM API
> (nouveau and radeon graphic drivers) to work under Xen. The explanation
> is a bit complex and I am not sure if I am explaining it that well..so if
> something is unclear please do ping me.
> 
> Changes since v1: [https://lkml.org/lkml/2010/12/6/516]
>  - Cleaned up commit message (forgot to add my SoB).

v1 was:
Tested-by: Ian Campbell <ian.campbell@citrix.com>
(actually I tested a backport to the 2.6.32.x Debian Squeeze kernel
which uses 2.6.33.x era DRM code, others have also reported success with
this backport in http://bugs.debian.org/602418)

Ian.

-- 
Ian Campbell

Did you know that for the price of a 280-Z you can buy two Z-80's?
		-- P. J. Plauger

