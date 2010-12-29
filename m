Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab0L2LSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 06:18:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44469 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0L2LSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 06:18:48 -0500
Date: Wed, 29 Dec 2010 12:18:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.37-rc8
Message-ID: <20101229111840.GA13498@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Len Brown <len.brown@intel.com>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 05:18:12PM -0800, Linus Torvalds wrote:
> Another week, another -rc. This should be the last for the 37 series,

There's also the issue with oopsing when physically removing the battery
from the system. I have a proposed fix but no acks/nacks from ACPI guys
yet:

https://patchwork.kernel.org/patch/418751/

-- 
Regards/Gruss,
Boris.
