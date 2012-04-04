Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2DDKqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:46:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44935 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab2DDKqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:46:46 -0400
Date: Wed, 4 Apr 2012 12:46:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Alessandro Rubini <rubini@cvml.unipv.it>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: psmouse serio4: bad data from KBC - timeout
Message-ID: <20120404104643.GA5193@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	Alessandro Rubini <rubini@ipvvis.unipv.it>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120403094324.GA3346@gere.osrc.amd.com>
 <20120403170659.GF24832@core.coreip.homeip.net>
 <20120404045440.GB28344@liondog.tnic>
 <20120404064053.GA26093@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120404064053.GA26093@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 11:40:53PM -0700, Dmitry Torokhov wrote:
> As I said I would start at the latest ACPI and PM merges and try
> reverting them - i8042 may interact in funny ways with embedded
> controller since it is usually the same piece of firmware.
> 
> I assume it works fine in 3.3, right?

Yes, it does.

Let me checkout git trees before those merges to see whether it makes
any difference.

Thanks.

-- 
Regards/Gruss,
Boris.
