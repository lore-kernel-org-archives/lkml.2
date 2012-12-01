Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2LARjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:39:00 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64343 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2LARi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdYk=YM97Hr2BpGwXsojV1UoEfxc=mCvSVR-8ZmhxytvwA@mail.gmail.com>
References: <1e773c8f35fed89f6eb6cc44f393fb76ba4ae3e2.1353929710.git.viresh.kumar@linaro.org>
	<CACRpkdYk=YM97Hr2BpGwXsojV1UoEfxc=mCvSVR-8ZmhxytvwA@mail.gmail.com>
Date: Sat, 1 Dec 2012 23:08:56 +0530
Message-ID: <CAKohpomwi3Fzkg51X2tw_VFqDvcCWdFrAOLn8RsuBwqKAT+S4A@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: stmpe: Add DT support for stmpe gpio
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        lee.jones@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 December 2012 22:17, Linus Walleij <linus.walleij@linaro.org> wrote:
> If you can, try to avoid this:
> Content-Type: text/plain; charset=WINDOWS-1252
> Content-Transfer-Encoding: quoted-printable
>
> That kind om message encoding makes my life a living hell
> (but I fixed it, manually editing the whole patch) how did you
> end up with this? Did you for example issue the command
> git send-email from a Windows machine using some Windows
> version of git?

I don't use windows for any linux work. I went through the header
to see what went wrong and realized, i sent this mail when i was in ARM's
office and via arm id only. i.e. using arm id's msmtprc settings. I don't
know why my linaro settings don't work from office, they work from
outside with no changes.

companies use microsoft exchange server and that played with this
patch. Sorry for making your life miserable :(

--
viresh
