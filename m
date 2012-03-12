Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2CLRDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:03:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50915 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab2CLRDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:03:49 -0400
MIME-Version: 1.0
In-Reply-To: <4F5E1ECC.1040605@atmel.com>
References: <20120309183732.512d3676599da324f4747219@canb.auug.org.au>
	<4F5E1ECC.1040605@atmel.com>
Date: Mon, 12 Mar 2012 12:03:48 -0500
Message-ID: <CAMXH7KH_vgri3EPRvkXR+LddRUc=0ve=4u7yr51utBfgV5bF3w@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the
 arm-soc tree
From: Rob Lee <rob.lee@linaro.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Stephen, Nicolas, Daniel,

On Mon, Mar 12, 2012 at 11:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 03/09/2012 08:37 AM, Stephen Rothwell :
>> Hi Rob,
>>
>> Today's linux-next merge of the cpuidle-cons tree got a conflict
>> in arch/arm/mach-at91/cpuidle.c between commit 00482a4078f4 ("ARM:
>> at91: implement the standby function for pm/cpuidle") from the
>> arm-soc tree and commit 7a1f6e72dce1 ("ARM: at91: Consolidate time
>> keeping and irq enable") from the cpuidle-cons tree.
>>
>> I fixed it up (I think - see below) and can carry the fix as
>> necessary.
>
> Yes: resolution correct. Please carry it.
>

Who should carry this fixup and related necessary at91 changes?  Me?
FYI, my at91 changes are dependent on my core cpuidle change, but my
core cpuidle changes do not require any at91 changes as the at91 and
other platform changes were only made to consolidate duplicate code.

Best Regards,
Rob

> Thanks to Rob and Daniel for their answers.
>

Thank you as well Nicolas.

> Best regards,
> - --
> Nicolas Ferre
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>
> iQEcBAEBAgAGBQJPXh7HAAoJEAf03oE53VmQSQwH/15D3okPxJSEiH0k8IFt6Df0
> RDY/CdaGYDllGMq7Yc1LiQAPrlHkv+gFNAJkhH8aJvC603pYBFGIa5IPLeZEE+XD
> MkXiO7pQAOdGtojqSrZI8Sp0kxtfdR6QlNu5o518yvlKIkxbWJoXdVty9+MuciOv
> GOR+164hJtlr4fLLg7bTzsdnxquDVBBbks9qLhSYEQBEuNkgXKgNfdMouwVI/Zuj
> sX9DSKnVVm5LS/rrq888JRPPtBf8/HkmOeFRWKktq7Q8WldQbBI79vj01osH++jf
> rwDiM/CSC0nhXY0IWEof+Hz1mSinM07XGZglDYwqI1ca7HId2C/txaFI3NtcC7A=
> =rZpG
> -----END PGP SIGNATURE-----
