Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab2CLQGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:06:04 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:4545 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2CLQGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:06:01 -0400
Message-ID: <4F5E1ECC.1040605@atmel.com>
Date: Mon, 12 Mar 2012 17:05:32 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Rob Lee <rob.lee@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the cpuidle-cons tree with the arm-soc
 tree
References: <20120309183732.512d3676599da324f4747219@canb.auug.org.au>
In-Reply-To: <20120309183732.512d3676599da324f4747219@canb.auug.org.au>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/09/2012 08:37 AM, Stephen Rothwell :
> Hi Rob,
> 
> Today's linux-next merge of the cpuidle-cons tree got a conflict
> in arch/arm/mach-at91/cpuidle.c between commit 00482a4078f4 ("ARM:
> at91: implement the standby function for pm/cpuidle") from the
> arm-soc tree and commit 7a1f6e72dce1 ("ARM: at91: Consolidate time
> keeping and irq enable") from the cpuidle-cons tree.
> 
> I fixed it up (I think - see below) and can carry the fix as
> necessary.

Yes: resolution correct. Please carry it.

Thanks to Rob and Daniel for their answers.

Best regards,
- -- 
Nicolas Ferre
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPXh7HAAoJEAf03oE53VmQSQwH/15D3okPxJSEiH0k8IFt6Df0
RDY/CdaGYDllGMq7Yc1LiQAPrlHkv+gFNAJkhH8aJvC603pYBFGIa5IPLeZEE+XD
MkXiO7pQAOdGtojqSrZI8Sp0kxtfdR6QlNu5o518yvlKIkxbWJoXdVty9+MuciOv
GOR+164hJtlr4fLLg7bTzsdnxquDVBBbks9qLhSYEQBEuNkgXKgNfdMouwVI/Zuj
sX9DSKnVVm5LS/rrq888JRPPtBf8/HkmOeFRWKktq7Q8WldQbBI79vj01osH++jf
rwDiM/CSC0nhXY0IWEof+Hz1mSinM07XGZglDYwqI1ca7HId2C/txaFI3NtcC7A=
=rZpG
-----END PGP SIGNATURE-----
