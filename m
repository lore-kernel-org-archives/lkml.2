Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab2FRGKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:10:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63275 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2FRGKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:10:09 -0400
MIME-Version: 1.0
In-Reply-To: <1339870396-6726-1-git-send-email-devendra.aaru@gmail.com>
References: <1339870396-6726-1-git-send-email-devendra.aaru@gmail.com>
Date: Mon, 18 Jun 2012 08:10:08 +0200
Message-ID: <CACRpkda3=sJPFCHE44fPbANEEYNxUzH09YwUOG9MMXi-Ea5h7Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/pinctrl-core: cleanup pinctrl_register
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 8:13 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> lots of places the ret is used just for non zero cases
> with out that also we can check the status of the function
> calls.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied, thanks!
Linus Walleij
