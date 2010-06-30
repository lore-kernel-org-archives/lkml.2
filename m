Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0F3WBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:01:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56972 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab0F3WBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:01:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tIaDgZj68GlMtFyIHXJArNqUsjvCF4gmbDmC3p2HStIWnSZphpunNKXsojaxTFV7Ro
         lpNWC5qFMUMc1BslMmn67T5I9oosQj7i3wLhCC5hVjFLZVhl2FWXAwIkYh5Q3nG5Wmh0
         sZpz/7SVcv5B4Klb3jBrphItubVfLfBMN7feE=
MIME-Version: 1.0
In-Reply-To: <2a81bf5506ce15ac839ca4fa58dc8af4112ff531.1277911346.git.siccegge@cs.fau.de>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<2a81bf5506ce15ac839ca4fa58dc8af4112ff531.1277911346.git.siccegge@cs.fau.de>
Date: Thu, 1 Jul 2010 00:00:59 +0200
X-Google-Sender-Auth: 9LQMfAqEcHtKzMk7Bv7XR3mgycQ
Message-ID: <AANLkTikyk4fu72kWFfxQyEV_GHTc5flLYytF9cnHDBE_@mail.gmail.com>
Subject: Re: [PATCH 31/33] Removing dead MACH_U300_BS26
From: Linus Walleij <linus.walleij@stericsson.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Russell King <linux@arm.linux.org.uk>, Jiri Kosina <jkosina@suse.cz>,
       Daniel Mack <daniel@caiaq.de>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/30 Christoph Egger <siccegge@cs.fau.de>:

> MACH_U300_BS26 doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

OK then,
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
