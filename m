Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab2DYQ51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:57:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45511 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab2DYQ5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:57:25 -0400
Date: Wed, 25 Apr 2012 18:57:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] AMD thresholding fixes
Message-ID: <20120425165730.GB18314@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@amd64.org>,
	EDAC devel <linux-edac@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1335369123-23196-1-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F170F3C53@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F170F3C53@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 04:49:52PM +0000, Luck, Tony wrote:
> > If there are no issues, I'll add the queue to linux-next (I don't see a
> > branch from ras.git in linux-next, btw, which is strange).
> 
> Patches so far have been flowing from "ras" to "tip" to "linus". It
> hasn't quite been clear how linux-next fits into this. If we export
> to -next, then are we planning on sending those directly to linus,
> bypassing tip?

That's actually a good point. Once in -tip, they're seeing linux-next
anyway.

Ok, Ingo, what would you guys rather have:

* ras tree -> linux-next -> we send pull request to Linus

or

* ras tree -> -tip -> linux-next (automatically due to tip daily merges)
-> you send pull request to Linus

I guess I'm fine with both, second one makes us even lazier :)

Thanks.

-- 
Regards/Gruss,
Boris.
