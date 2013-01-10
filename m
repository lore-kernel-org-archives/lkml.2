Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3AJKWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:22:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3AJKV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:21:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 1/4] arm: vt8500: Add support for Wondermedia WM8750/WM8850
Date: Thu, 10 Jan 2013 10:21:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        vt8500-wm8505-linux-kernel@googlegroups.com, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz> <201301092127.05804.arnd@arndb.de> <1357783407.28830.2.camel@gitbox>
In-Reply-To: <1357783407.28830.2.camel@gitbox>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301101021.44238.arnd@arndb.de>
X-Provags-ID: V02:K0:SFJawzUV0n8F/wEzho0BkBpCzqnKDjKIfBdk/GHoKxe
 zLZkPHnDNj6T6fpv/MZUqUtxO6mG2Ety8s5RbqWU0rF6/7wYEg
 rOxTAJg8xPdIQDnuuWdHRrYs/biyrtdFux1Z5q8yfMo6v21tur
 v278+DVMpj6AAOq3+ttw15klMLfNCJmLYCOpLJVITqq1Q1h3Na
 w13ZxXyQAK1Grkm+yagupA9AZmIcH15thEZAhDoD/JkRTmT0Uv
 mVEqsqZRfXgLVGrWJZNm7evInTesw8gQl0+ZrzctVQsVw1G/Nx
 S0HfZDVvDC8nmjOBl43uS1a/2k/0mayEwQKOh8fJGq4lHAH+Vy
 8kuizU15U579wAiv+HBc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013, Tony Prisk wrote:
> On Wed, 2013-01-09 at 21:27 +0000, Arnd Bergmann wrote:
> > 
> > > Should patches in pull-requests have Ack'd lines already?
> 
> This is what I thought - and the reason I haven't sent a pull-request
> for the patch's - I haven't had any Ack's :)
> 

Sorry, I think I misunderstood the question then. I meant that if
you received an Acked-by statement, it should be part of the
changeset comment by the time you send a pull request.

There is also the rule that patches need to be reviewed on the
mailing list before you submit them for inclusion. Like all
rules, this can be bent a little for patches that are obvious
correct bug fixes, especially when you are the platform
maintainer. What you can do here is send the patches out to the
mailing list without any additional Acks and send the pull
request as the [PATCH 0/X] mail. We can then look at the
patches if necessary or just pull in the branch straight away.

	Arnd
