Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2JDWKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:10:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56495 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2JDWJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:09:58 -0400
Message-ID: <506E092A.6050405@zytor.com>
Date: Thu, 04 Oct 2012 15:09:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Disintegrate UAPI for x86
References: <17459.1349380319@warthog.procyon.org.uk>
In-Reply-To: <17459.1349380319@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 12:51 PM, David Howells wrote:
> Can you merge the following branch into the x86 tree please.
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
>    git://git.infradead.org/users/dhowells/linux-headers.git disintegrate-x86
>
> for you to fetch changes up to c64630429a9d37a248c6b06a738fad838f2f5e37:
>
>    UAPI: (Scripted) Disintegrate arch/x86/include/asm (2012-10-04 18:21:45 +0100)
>

That branch does have generic patches which are not yet in upstream.  I 
presume that is intentional.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

