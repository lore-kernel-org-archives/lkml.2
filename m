Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2DDGre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:47:34 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:41774 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2DDGrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:47:33 -0400
Message-ID: <4F7BEE91.1070309@ladisch.de>
Date: Wed, 04 Apr 2012 08:47:45 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Dave Airlie <airlied@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix warnings from vgaarb.h
References: <alpine.SOC.1.00.1204040912210.26551@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1204040912210.26551@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
> in 3.4-rc1-144, I get the following warnings. Fix them by including
> <linux/pci.h> to get struct pci_dev.
>
>   CC [M]  drivers/gpu/drm/i915/intel_display.o
> In file included from drivers/gpu/drm/i915/intel_display.c:33:0:
> include/linux/vgaarb.h:66:9: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]

Or you could simply declare it:

  struct pci_dev;


Regards,
Clemens
