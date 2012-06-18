Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2FRLrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:47:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2FRLrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:47:22 -0400
MIME-Version: 1.0
Date: Mon, 18 Jun 2012 17:17:22 +0530
Message-ID: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
Subject: Q: return of pinctrl_register and handing at drivers that use this function
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since the pinctrl_register returns a pointer of structure type "struct
pinctrl_dev" or NULL if it was failed to register the pinctrl driver,
so IS_ERR checking is not required?

My understanding about IS_ERR is that its used when the pointer
addresses are kind of error codes rather actual addresses,
but are a kind of return codes of functions returning integer types.

Please correct me if my understanding is not correct.

Thanks,
Devendra.
