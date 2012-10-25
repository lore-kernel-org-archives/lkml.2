Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946073Ab2JYP53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:57:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41089 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab2JYP50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:57:26 -0400
Date: Thu, 25 Oct 2012 17:57:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Denis Kirjanov <kirjanov@gmail.com>, dougthompson@xmission.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] handle error path in edac_mc_sysfs_init()
Message-ID: <20121025155729.GG308@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Denis Kirjanov <kirjanov@gmail.com>, dougthompson@xmission.com,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1351179778-6591-1-git-send-email-kirjanov@gmail.com>
 <20121025155606.GF308@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121025155606.GF308@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 05:56:06PM +0200, Borislav Petkov wrote:
> Would you be willing to fix that too, while you're at it? Btw, I can
> totally understand if you say no - I'll take care of it myself instead
> then :-).

Ah, maybe I should look at the second patch before replying to this one.
Nevermind, I'll merge the two into one and test.

Thanks.

-- 
Regards/Gruss,
Boris.
