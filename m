Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0LSUxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 15:53:25 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:58410 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0LSUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 15:53:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=lUmTOx1IJvoLSrmo2EEybpX/21AzvL7RWQEQ2ws+lmwnO7zcZ47LXffxzAhxndR+9e
         pCPnvB/gGzsPnzp1KDK7bA9qf50huOMZ5y7qfMM9dPfKUO7gJh2Ci65rYWimHEyBDugh
         JWjwEQ8Rw3Vpvi1Cpf20HjXeJz25k4+cbxyow=
MIME-Version: 1.0
In-Reply-To: <1291388753-14662-4-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
	<1291388753-14662-4-git-send-email-sundar.iyer@stericsson.com>
Date: Sun, 19 Dec 2010 21:53:23 +0100
X-Google-Sender-Auth: tq_1cYJuC5s7YOFCUToYAHIPjFU
Message-ID: <AANLkTikMtL=+HJfivh2MVfyzNvT8NyRXVcgPJNEV9XQu@mail.gmail.com>
Subject: Re: [PATCH 03/20] mach-ux500: move keymaps to new file
From: Linus Walleij <linus.walleij@linaro.org>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, dmitry.torokhov@gmail.com,
        sameo@linux.intel.com, ben-linux@fluff.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/3 Sundar Iyer <sundar.iyer@stericsson.com>:

> Move keylayouts to a dedicated file and plug these keylayouts
> for input platform data. This will make addition of new and custom
> keylayouts localized.

Managed to rebase this somewhat easily on top of the last
batch of tc3589x MFD patches and pushed for ux500-core,
please check that I didn't screw anything up.

Yours,
Linus Walleij
