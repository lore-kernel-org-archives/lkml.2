Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2LAQr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:47:28 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53100 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2LAQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <1e773c8f35fed89f6eb6cc44f393fb76ba4ae3e2.1353929710.git.viresh.kumar@linaro.org>
References: <1e773c8f35fed89f6eb6cc44f393fb76ba4ae3e2.1353929710.git.viresh.kumar@linaro.org>
Date: Sat, 1 Dec 2012 17:47:25 +0100
Message-ID: <CACRpkdYk=YM97Hr2BpGwXsojV1UoEfxc=mCvSVR-8ZmhxytvwA@mail.gmail.com>
Subject: Re: [PATCH V2] gpio: stmpe: Add DT support for stmpe gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        lee.jones@linaro.org, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 12:36 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>
> This patch allows the STMPE GPIO driver to be successfully probed and
> initialised when Device Tree support is enabled. Bindings are mentioned in
> Documentation too.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V1->V2:
> - Fixed norequest-mask as st,norequest-mask in Binding Documentation
> - Added Acked-by from Lee Jones

Patch applied, looks good.

Grant and I will synchronize our trees continously.

If you can, try to avoid this:
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

That kind om message encoding makes my life a living hell
(but I fixed it, manually editing the whole patch) how did you
end up with this? Did you for example issue the command
git send-email from a Windows machine using some Windows
version of git?

Yours,
Linus Walleij
