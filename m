Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1EJVDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:03:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60777 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1EJVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:03:23 -0400
Date: Tue, 10 May 2011 22:03:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Taylor Hutt <thutt@chromium.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CHROMIUM: ASoC: Remove 'const' modifiers which cause
	warnings during compilation.
Message-ID: <20110510210319.GA17589@sirena.org.uk>
References: <1305054860-16054-1-git-send-email-thutt@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305054860-16054-1-git-send-email-thutt@chromium.org>
X-Cookie: Interchangeable parts won't.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:14:20PM -0700, Taylor Hutt wrote:
> This change removes a warning produced when 'const * const' values
> are assigned to a 'const **'.
>
> These code being modified originally came from these two commits:
> 
>     http://git.kernel.org/?p=linux/kernel/git/broonie/sound-2.6.git;a=commit;h=82a5a936f6dea13849d93a2899a9b7294a8db336
>     http://git.kernel.org/?p=linux/kernel/git/broonie/sound-2.6.git;a=commit;h=dad31ec133adb20c8fd10bfd9379da3f08b8721e
> 
> Change-Id: I964ff6d24aafe78c2db7002abfd03b9069db9687
> Signed-off-by: Taylor Hutt <thutt@chromium.org>

This is already fixed in -next.

Please follow the patch submission procedure in SubmittingPatches, in
particular:

- Send patches to the relevant maintainers and mailing lists.
- Don't include "CHROMIUM" or other local things like gerritt artifacts
  in your changelog.

If you don't send patches to the maintainers there's a reasonable chance
they'll never see them, and the changelog stuff is just irrelevant and
makes it harder to apply the patch as the maintainer has to manually
remove them.
