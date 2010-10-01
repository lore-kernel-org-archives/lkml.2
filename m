Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0JAL1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:27:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39449 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab0JAL1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DG7DUQeJLyfeBkDyFY/HTiuTQVzcR4AdTRKDwYdTlXd2KDQ9YW2wPLYnNv9Q/MTOOQ
         HT2aEr3HG80ojV3Mi2fgwOaZSypp9vpM0cvk07giJ2ORO+t226rsuBWJkClA9XjSgv7K
         PcsNMcmfB0+Ka/atBcQusENnKYDOekh2Y5aOo=
MIME-Version: 1.0
In-Reply-To: <1285916771-18033-6-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	<1285916771-18033-6-git-send-email-imunsie@au1.ibm.com>
Date: Fri, 1 Oct 2010 07:27:37 -0400
Message-ID: <AANLkTins34TrEWj618_4XBRwGGFqRSehwWEp7jBubvsu@mail.gmail.com>
Subject: Re: [PATCH 05/18] powerpc: Wire up 44x little endian boot for
 remaining 44x targets
From: Josh Boyer <jwboyer@gmail.com>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 3:05 AM, Ian Munsie <imunsie@au1.ibm.com> wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
>
> I haven't tested booting a little endian kernel on any of these targets,
> but they all claim to be 44x so my little endian trampoline should work
> on all of them, so wire it up on:
>
> bamboo
> katmai
> kilauea
> rainer
> sam440ep
> sequoia
> warp
> yosemite
> ebony
>
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>

I see no reason to do this at all.  If you haven't tested them and
there is no demand, there's no reason to wire them up.  Some might
actively want to disallow LE mode anyway, like the Warp or Sam440EP.

josh
