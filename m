Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2LRScL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:32:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45260 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2LRScI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:32:08 -0500
Date: Tue, 18 Dec 2012 19:32:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121218183206.GG31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
 <20121218171915.GE31255@liondog.tnic>
 <20121218173024.GA18732@jshin-Toonie>
 <20121218180945.GA21573@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121218180945.GA21573@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:09:45PM -0600, Jacob Shin wrote:
> I think I meant to say as in uu_msgs[] above. HWA stands for "Hardware
> Assertion" ..

Yep, I got it. You mean this:

const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };

and HWA is bit setting 0x2. You don't need to add a comment to say what
HWA means because I'm assuming the BKDG will have it when it comes out.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
