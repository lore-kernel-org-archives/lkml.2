Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2FROi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:38:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36146 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2FROiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:38:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaPFtO1bRC3TdLx8MSgFMznr5FBXV5DdUyasNAcF34s3mQ@mail.gmail.com>
References: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
	<CACRpkda5nYmAT3-fkxdYQEGpi6U=L-kphQEu3naoxPzO9a-7pQ@mail.gmail.com>
	<CAHdPZaPFtO1bRC3TdLx8MSgFMznr5FBXV5DdUyasNAcF34s3mQ@mail.gmail.com>
Date: Mon, 18 Jun 2012 16:38:54 +0200
Message-ID: <CACRpkdYB9wPuCH=U3V5EJAhj6Ob2HowUFYT7Q0nqtOYyf7asUQ@mail.gmail.com>
Subject: Re: Q: return of pinctrl_register and handing at drivers that use
 this function
From: Linus Walleij <linus.walleij@linaro.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 2:04 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:

> So checking the return value of pinctrl_register with IS_ERR is not required.

Nope.

> There are drivers in pinctrl subsystem which uses the IS_ERR and may (not)
> check whether its null or not.
>
> you can expect a patchset of those fixes. :)

Good :-)

Thanks,
Linus Walleij
