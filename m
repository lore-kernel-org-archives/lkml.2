Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0LAMj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:39:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50860 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0LAMj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:39:26 -0500
Date: Wed, 1 Dec 2010 13:39:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101201123921.GA15530@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tobias Karnat <tobias.karnat@googlemail.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1291201307.3029.21.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1291201307.3029.21.camel@Tobias-Karnat>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 12:01:47PM +0100, Tobias Karnat wrote:
> Hi,
> 
> I have a problem with the edac_core module in 2.6.36.1, it crashes on shutdown.
> If I remove it manually, it does not crash.
> 
> I compiled the edac modules from 2.6.35 against the headers of 2.6.36.1 and they are fine.

What does that mean? Are you using an official kernel version or
something you cooked up?

> Screenshot of the crash:
> 
> http://oi51.tinypic.com/r9mu55.jpg

Please try to catch the whole oops. I can see rIP but it'd be much more
helpful to see the calltrace and the whole register dump which are cut
off at the bottom of your pic.

Thanks.

-- 
Regards/Gruss,
Boris.
