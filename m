Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2C1Mec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:34:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2C1Meb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:34:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [GIT PULL 1/5] ARM: cleanups of io includes
Date: Wed, 28 Mar 2012 12:34:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1332918842-13521-1-git-send-email-olof@lixom.net> <20120328082501.GA22414@n2100.arm.linux.org.uk> <CAOesGMjwZOON9kFNvaEq8QhSvjAgsJT_J1Ysb9-AbePd6g+-rQ@mail.gmail.com>
In-Reply-To: <CAOesGMjwZOON9kFNvaEq8QhSvjAgsJT_J1Ysb9-AbePd6g+-rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203281234.10632.arnd@arndb.de>
X-Provags-ID: V02:K0:GYTkIabrvCeaAsKrSQMgQ/5yA5nzhhhQ2Hhlpk619ON
 IBorNVyNvAhoN2h2bfJlhiFtP3U0v8L1Bxc+DUvs0nwree/pac
 EJTTfB4oQlHNXY5N7bMuF+05PUAB4/SdVo0LZ8d4iPYcbErYGp
 xwsAyIlnrCUlAcDl8jH/Ta0votdx3ZMFxz1U3BAQ52HawHcfaU
 SMwAo/E6i5lgWovxWzfzR+r75fFJQjiEU1KKUkXk7b/on6EYEF
 6+4IKuRzccp3mWLAzP9EHo3La9hWIvYis3eoMtdjqSxqr69ICv
 HyUXPRcCzqMDAUyW9vHr1xYjpe+9hVoENrgp9qraYx4kISZDae
 7uKPqwO0xRH/t6dnaT2o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 March 2012, Olof Johansson wrote:
> If you prefer to let it sit in linux-next for a day or two before
> going in, that's fine. But I verified that the original build problem
> introduced was fixed before I sent it out.
> 
> Unfortunately, PXA is also broken due to the regulator changes
> mentioned in the above referenced mail, which is already upstream and
> unrelated to the changes in this branch.
> 
> Linus; the rest of the pull requests should be OK to go in
> independently of this, so please go ahead with those if you don't
> mind. The only changes to those branches in the last few days is the
> merge resolution I did to the drivers2 branch/tag.

Yes, sounds good. I've also verified that none of the other branches
depends on this one.

	Arnd
