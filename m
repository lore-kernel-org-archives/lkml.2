Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2DGAWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:22:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53052 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2DGAWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:22:31 -0400
MIME-Version: 1.0
In-Reply-To: <87mx6o3b7d.fsf@laptop.org>
References: <87mx6o3b7d.fsf@laptop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Apr 2012 17:22:10 -0700
X-Google-Sender-Auth: pNXkgHd1phEEPKbYNoxkjAwUdoM
Message-ID: <CA+55aFxSARUvsOGX6s5MoH+i_Pw6kU=Qt3Z1Ei_1xvJWFcx8kQ@mail.gmail.com>
Subject: Re: [GIT PULL] MMC fixes for 3.4-rc2
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 12:35 PM, Chris Ball <cjb@laptop.org> wrote:
>
> Please pull from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus
>
> to receive MMC fixes for 3.4-rc2.  I've signed an "mmc-fixes-for-3.4-rc2"
> tag.

Please just ask my to pull the tag directly, don't say "please pull
this branch", and then add "oh, but there's this tag also".

I already did the "cut-and-paste" for the pull, and then I realized
that I'm not seeing the message that your email implied was there, and
then I noticed that you talked about the tag separately.

That just messes everything up. Don't even bother mentioning the
worthless branch. The tag has everything the branch has, _and_ the
message.

So just ask me to pull it, with a

  Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
mmc-fixes-for-3.4-rc2

rather than make it unnecessarily more complicated and error-prone.

                   Linus
