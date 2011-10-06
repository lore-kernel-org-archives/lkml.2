Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab1JFNEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:04:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46592 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758262Ab1JFNE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <4E8DA6E7.3010105@gmail.com>
References: <20111003203249.GA22113@kroah.com>
	<4E8DA6E7.3010105@gmail.com>
Date: Thu, 6 Oct 2011 09:04:28 -0400
Message-ID: <CA+5PVA6YMDQYT6N8BdB2MHj2DupzVt4AFoFGABOAft+mN7wd8Q@mail.gmail.com>
Subject: Re: Linux 3.0.5
From: Josh Boyer <jwboyer@gmail.com>
To: =?ISO-8859-1?Q?Sven_K=F6hler?= <sven.koehler@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@linux.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 9:02 AM, Sven Köhler <sven.koehler@gmail.com> wrote:
> There's an error in 3.0.5:
>
> # LANG=C make all
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHK     include/generated/compile.h
>  CC      drivers/gpu/drm/radeon/r100.o
> drivers/gpu/drm/radeon/r100.c: In function 'r100_copy_blit':
> drivers/gpu/drm/radeon/r100.c:776:27: error: 'num_pages' undeclared
> (first use in this function)
> drivers/gpu/drm/radeon/r100.c:776:27: note: each undeclared identifier
> is reported only once for each function it appears in
> make[4]: *** [drivers/gpu/drm/radeon/r100.o] Error 1
> make[3]: *** [drivers/gpu/drm/radeon] Error 2
> make[2]: *** [drivers/gpu/drm] Error 2
> make[1]: *** [drivers/gpu] Error 2
> make: *** [drivers] Error 2

Greg released 3.0.6 almost immediately after 3.0.5 to fix this issue.

josh
