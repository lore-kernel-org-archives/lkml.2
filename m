Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962Ab0GVKk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 06:40:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62960 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab0GVKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 06:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XSFyBpK8//JRhRSzudIsRjtIzC0E/VhPDZ6frmkEOG2RjlnESLYSqVerg6GaFfuyLx
         MAq9PBovSgYGVfq8NAlY9inZhtrLCzCTR4yQERxGYAwR8fxUSEZNWGQEUSYYiJWjx4SW
         RN2fDjVVafCXyYhsh8jY3dY+ZhA3RMfv2Guh0=
MIME-Version: 1.0
In-Reply-To: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
References: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 22 Jul 2010 12:40:26 +0200
Message-ID: <AANLkTimmJJcMXxICZHjksp_TjqO_JRx9HwCTJ6UpZQOZ@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/21 Linus Walleij <linus.walleij@stericsson.com>:

> This adds an interface to the DMAengine to make it possible to
> reconfigure a slave channel at runtime. We add a few foreseen
> config parameters to the passed struct, with a void * pointer
> for custom per-device or per-platform runtime slave data.

BTW Vinod, if you're happy with this API, then please ACK it so
Dan has some indication whether it'll fit the Moorestown too.

Yours,
Linus Walleij
