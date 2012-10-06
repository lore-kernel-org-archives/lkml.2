Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2JFIvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:51:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42925 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2JFIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:51:25 -0400
Message-ID: <506FF10A.8030600@monstr.eu>
Date: Sat, 06 Oct 2012 10:51:22 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for microblaze
References: <17386.1349380289@warthog.procyon.org.uk>
In-Reply-To: <17386.1349380289@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 10/04/2012 09:51 PM, David Howells wrote:
> Can you merge the following branch into the microblaze tree please.
>
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
>
> Note that there are some fixup patches which are at the base of the branch
> aimed at you, plus all arches get the asm-generic branch merged in too.
>
> The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:
>
>    Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)
>
> are available in the git repository at:
>
>
>    git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-microblaze


I have added this to our internal testing repository and I will start to do some tests.

I expect your intention is to merge this to mainline in current merge window, right?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
