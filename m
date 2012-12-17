Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2LQSOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 13:14:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34079 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563Ab2LQSOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 13:14:41 -0500
Date: Mon, 17 Dec 2012 19:14:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI: Overriding ACPI tables via initrd only works
 with an initrd
Message-ID: <20121217181435.GD31866@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
References: <1351694147-10904-1-git-send-email-trenn@suse.de>
 <1351694147-10904-4-git-send-email-trenn@suse.de>
 <20121217092802.GA31947@liondog.tnic>
 <50CF5FB4.8090305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CF5FB4.8090305@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 10:08:52AM -0800, H. Peter Anvin wrote:
> Hm... all these are actually cleanups or fixes for the stuff that is
> now upstream, I believe... as minor fixes I think these can be pushed
> post-rc1 if we don't get to them sooner but it looks like they are all
> needed.

/me is nodding in an agreeing manner after a quick glance over them.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
