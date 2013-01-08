Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3AHXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:02:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37303 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab3AHXCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:02:16 -0500
Date: Wed, 9 Jan 2013 00:02:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: x86, MCE: Retract most UAPI exports
Message-ID: <20130108230213.GA28869@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20121221163455.GG15204@liondog.tnic>
 <CA+8MBb+yxuLtJhAzOWqcEtmhbF11iXXJymQ8Wyxq3CSJ-nfuLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBb+yxuLtJhAzOWqcEtmhbF11iXXJymQ8Wyxq3CSJ-nfuLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 02:57:26PM -0800, Tony Luck wrote:
> I think we should also pull "struct mce_log" definition back too. It's
> purely an internal structure. "struct mce" is the only bit that is
> user space visible via /dev/mcelog.

Yes, you're right.

> I.e. the uapi version should only contain the "struct mce" definition
> and the three ioctl codes.

Great, thanks for looking at this. I'll redo the patch tomorrow and send
to x86 guys.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
