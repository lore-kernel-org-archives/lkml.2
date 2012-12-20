Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2LTPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:37:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51705 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab2LTPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:37:18 -0500
Date: Thu, 20 Dec 2012 16:37:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Shut up annoying native_sectors warning
Message-ID: <20121220153714.GD26635@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
References: <1356006355-6819-1-git-send-email-bp@alien8.de>
 <20121220130159.7125e700@pyramind.ukuu.org.uk>
 <20121220150423.GC26635@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121220150423.GC26635@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 04:04:23PM +0100, Borislav Petkov wrote:
> On Thu, Dec 20, 2012 at 01:01:59PM +0000, Alan Cox wrote:
> > Net lose IMHO - better to file a gcc bug report
> Ok, I'll try that. Want on CC?

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55759

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
