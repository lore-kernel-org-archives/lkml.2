Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1HYMx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:53:26 -0400
Received: from antcom.de ([188.40.178.216]:45383 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1HYMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:53:24 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Aug 2011 08:53:24 EDT
Message-ID: <4E564417.10304@antcom.de>
Date: Thu, 25 Aug 2011 14:46:15 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.18) Gecko/20110626 Iceowl/1.0b2 Icedove/3.1.11
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "mkuboot.sh: Fail if mkimage is missing"
References: <alpine.LNX.2.00.1108251353050.13644@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1108251353050.13644@pobox.suse.cz>
X-Enigmail-Version: 1.1.1
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/25/2011 01:53 PM, Jiri Kosina wrote:
> It causes the whole build to fail when mkimage is not found. This doesn't
> seem right, as the failure is not fatal for the rest of the build.

I disagree. As I understand, mkimage is only used on "make uImage". When
I do this and the tool producing the uImage (i.e. the final target) is
missing or can't produce the target otherwise, I expect an error.
Otherwise, this problem would be silently ignored. That's why I created
the original patch in the first place.

Please tell me if I missed come fact.

Thanks for considering,

Roland
