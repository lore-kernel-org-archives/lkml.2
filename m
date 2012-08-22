Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2HVFvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:51:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36642 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab2HVFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1208220501320.761@skynet.skynet.ie>
References: <alpine.DEB.2.00.1208220501320.761@skynet.skynet.ie>
Date: Wed, 22 Aug 2012 15:51:06 +1000
Message-ID: <CAPM=9tynS56c29B97LWrvodwQ1CXv0UpJDdEqLrfPeUBYuhcnw@mail.gmail.com>
Subject: Re: [git pull] drm fixes + one fbcon one
From: Dave Airlie <airlied@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 2:06 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> Hi Linus,
>
> Intel: edid fixes, power consumption fix, s/r fix, haswell fix
> radeon: BIOS loading fixes for UEFI and Thunderbolt machines, better MSAA
> validation, lockup timeout fixes, modesetting fixes
> one udl dpms fix,
> one vmwgfx fix,
> couple of trivial core changes
>
> There is an export added to ACPI as part of the radeon bios fixes,
>
> I've also included the fbcon flashing cursor vs deinit race fix, that
> seems the simplest place to start, so that distros can pick it up easier.

Me notices now you've already pulled the fbcon fix, let me know if you
want me to drop my one, or just
pull in the commit above it in my tree,
27fc4f1c0be917b1e5cef934783f9b09e28e92ea also now a branch
in the same tree called drm-fixes-no-fbcon.

Dave.
