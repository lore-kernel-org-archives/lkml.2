Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab2FHNmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:42:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38325 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2FHNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:42:11 -0400
Message-ID: <4FD2012F.60309@gmail.com>
Date: Fri, 08 Jun 2012 15:42:07 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/82] 3.2.20-stable review
References: <20120608041840.861504477@decadent.org.uk>
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 08-06-12 06:18, Ben Hutchings schreef:
> This is the start of the stable review cycle for the 3.2.20 release.
> There are 82 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jun 10 13:00:00 UTC 2012.
> Anything received after that time might be too late.
>
> A combined patch relative to 3.2.19 will be posted as an additional
> response to this, and the diffstat can be found below.
Is it too late to nominate patches?

These 3 would be nice to have for nouveau, second patch introduced a regression
with macbook pros fixed by the third commit (in 3.5rc1):

commit 6322175530c89ab719cea28202f96a3660491727
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon Oct 17 10:24:49 2011 +1000

    drm/nouveau: determine a value for display_info.bpc if edid doesn't

commit c8435362f2211086b34ce871fa9c3fcc7ca79ff9
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Sat Mar 24 16:26:13 2012 +1000

    drm/nouveau: default to 8bpc for non-LVDS panels if EDID isn't useful
   
commit a6a17859f1bdf607650ee055101f54c5f207762b
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Sat May 5 00:39:21 2012 +1000

    drm/nouveau/disp: fix dithering not being enabled on some eDP macbooks
   
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

