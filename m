Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab1JDPso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:48:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1391 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab1JDPsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:48:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Oct 2011 08:48:35 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Date: Tue, 4 Oct 2011 08:48:33 -0700
Subject: RE: linux-next: manual merge of the arm-soc tree with the arm tree
Thread-Topic: linux-next: manual merge of the arm-soc tree with the arm tree
Thread-Index: AcyCKcOtISl97dPdTKKaObf3kDiw4AAgtO3g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6F74@HQMAIL01.nvidia.com>
References: <20111004110831.a4d6d72a9b75a38265c9d6a1@canb.auug.org.au>
In-Reply-To: <20111004110831.a4d6d72a9b75a38265c9d6a1@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote at Monday, October 03, 2011 6:09 PM:
> Hi Arnd,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-tegra/board-seaboard.h between commit ea5abbd215b7 ("ARM:
> 7101/1: arm/tegra: Replace <mach/gpio.h> with <mach/gpio-tegra.h>") from
> the arm tree and commit a697e694aeb8 ("ARM: Tegra: Seaboard board updates
> for audio") from the arm-soc tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Both this and the similar fixup in the other email look fine to me.

For my education, how does this get resolved; presumably neither Russell's
tree nor arm-soc can take a patch that fixes this right now, so does one of
the trees get rebased after the merge of the other but before being pulled
by Linus, or does Linus do this merge fixup when he pulls?

Thanks for cluing me in!

-- 
nvpublic

