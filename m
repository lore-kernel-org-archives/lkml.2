Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768178Ab2KOPGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:06:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56462 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768118Ab2KOPGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:06:51 -0500
Date: Thu, 15 Nov 2012 16:07:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 7/9] bug.h: Make BUILD_BUG_ON generate compile-time
 error
Message-ID: <20121115150708.GC4956@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com>
 <1352844821-18952-7-git-send-email-daniel.santos@pobox.com>
 <50A2C88F.5010902@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50A2C88F.5010902@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:24:15PM -0600, Daniel Santos wrote:
> Borislav,
> 
> Please note that this patch has changed slightly since you Acked it.  I
> have moved the location of the negative-size array code to the end of
> the macro.  I don't think this really matters honestly, but I figured
> this was the best place to put that change.

Yes, that's fine.

Thanks.

-- 
Regards/Gruss,
Boris.
