Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab1FIXIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:08:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35412 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1FIXIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hBnYtEbcOaMfNe3J+Px4OsmTPiwT9NROLfp1I1mkn4peqoTJTY/DI6YvdBdah9CGep
         1rcpx+7TJzFVFP9sHoGrMC3rbE7wDvskwBOmWsI/i+4+zq2+nJXmANOetZU7FeITdWMD
         B1vdHd45io7InvPBd/9n7eW3bNxoYGgF4reFE=
MIME-Version: 1.0
In-Reply-To: <20110609180604.7cac8b5a.jay.estabrook_gmail.com@gmail.com>
References: <20110609180604.7cac8b5a.jay.estabrook_gmail.com@gmail.com>
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 9 Jun 2011 19:07:54 -0400
Message-ID: <BANLkTimZ02p83xpsLDXJz3Wv7zQQz6=Kig@mail.gmail.com>
Subject: Re: [PATCH 0/3] alpha, drm: Update Alpha DRM support
To: Jay Estabrook <jay.estabrook@gmail.com>
Cc: linux-alpha <linux-alpha@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, airlied@linux.ie,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 6:06 PM, Jay Estabrook <jay.estabrook@gmail.com> wrote:
>
> This patch set fixes Alpha-specific support in the DRM code,
> allowing Radeon KMS and the MGA driver to work properly on
> Alpha-based machines.
>
> Jay
>
> Jay Estabrook (3):
>  alpha, drm: Update Alpha DRM support
>  alpha, drm: Cleanup Alpha support in DRM generic code
>  alpha, drm: Remove obsolete Alpha support in MGA DRM code
>  alpha, drm: Add Alpha support to Radeon DRM code
>
>  drivers/gpu/drm/drm_bufs.c          |    3 ---
>  drivers/gpu/drm/drm_vm.c            |    2 +-
>  drivers/gpu/drm/mga/mga_drv.h       |   19 -------------------
>  drivers/gpu/drm/radeon/radeon_ttm.c |   23 +++++++++++++++++++++++
>  4 files changed, 24 insertions(+), 23 deletions(-)

Patches 1 and 3 are

Tested-by: Matt Turner <mattst88@gmail.com>

They also fix

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=23227

In that report, Michel Danzer had some comments about the patch, so
I'm CC'ing him.

Thanks!
Matt
