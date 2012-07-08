Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2GHTDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:03:40 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:53405 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GHTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:03:39 -0400
X-Greylist: delayed 1950 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2012 15:03:39 EDT
Message-ID: <4FF9D1E9.4050504@jonmasters.org>
Date: Sun, 08 Jul 2012 14:31:05 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com> <201207071927.13135.arnd@arndb.de> <4FF93C99.80203@redhat.com>
In-Reply-To: <4FF93C99.80203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 03:54 AM, Jon Masters wrote:

> In our bikeshedding conversations pondering future Fedora support, we've
> pretty much settled on the aarch64 name now, and the hope is that we can
> also avoid providing 32-bit compatibility (multi-arch) by relying on
> virtualized guests for any 32-bit story. If that holds, we have some
> flexibility to e.g. go for 64K page size, etc. if we want.

Let me rephrase that to avoid missunderstanding. I am the strongest
advocate of the "aarch64" name on our end. Others disagreed with that,
but when the tooling, kernel, and other stuff settled on the same
uniform name, it was my understanding that this was de facto settled.
However, it would be wrong to say there are not dissenting viewpoints.

My biggest fear here, however, is that we end up bikeshedding this to
death, and we then have some use of one name, some of "arm64", and
distros failing to agree on things like the correct triplet to use for
the new architecture (we had some issues with this before). So, if we're
going to argue over the name and make changes, let's do it now. There
seems to be no value in the toolchain using one name, which is already
upstream, and the kernel using another name.

Jon.
