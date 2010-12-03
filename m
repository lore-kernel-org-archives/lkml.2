Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0LCG3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:29:19 -0500
Received: from smtp.nokia.com ([147.243.1.48]:59957 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab0LCG3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:29:17 -0500
From: <ext-jarkko.2.sakkinen@nokia.com>
To: <jmorris@namei.org>, <casey@schaufler-ca.com>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>
Subject: VS: [PATCH] Smack: label for task objects (retry 2)
Thread-Topic: [PATCH] Smack: label for task objects (retry 2)
Thread-Index: AcuMluqw+h/aC3/KR7KF4frfif+EvgFo5IiAAAkZzAAAAhwEAAASykyk
Date: Fri, 3 Dec 2010 06:27:44 +0000
Message-ID: <E3D0B314C5E55043AC59C5FBDB298310EE11A5@008-AM1MPN1-005.mgdnok.nokia.com>
References: <4CEE4D6E.4030204@nokia.com> <4CF7D16D.4060009@schaufler-ca.com>
 <alpine.LRH.2.00.1012030823150.25347@tundra.namei.org>,<alpine.LRH.2.00.1012030923560.26002@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1012030923560.26002@tundra.namei.org>
Accept-Language: fi-FI, en-US
Content-Language: fi-FI
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Dec 2010 06:27:47.0319 (UTC) FILETIME=[33A12070:01CB92B3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I don't like to whine about unnecessary things but it would really nice to get into the author field :) The patch that I sent to list did have merge issues. I  don't know what messed it.

Casey, I propose we take some steps back and fix the workflow so next time things will go smoother. I propose that I create my own tree from your tree and put patch there and you can then cherry pick or merge my patch to his tree.  Then James can pick the patch from your tree.

BR, Jarkko
________________________________________
Lähettäjä: ext James Morris [jmorris@namei.org]
Lähetetty: 3. joulukuuta 2010 0:24
Vastaanottaja: Casey Schaufler
Kopio: Sakkinen Jarkko.2 (EXT-Tieto/Tampere); linux-kernel@vger.kernel.org; linux-security-module@vger.kernel.org
Aihe: Re: [PATCH] Smack: label for task objects (retry 2)

On Fri, 3 Dec 2010, James Morris wrote:

> On Thu, 2 Dec 2010, Casey Schaufler wrote:
>
> > After patch clean-up applied to:
> >
> >   git://gitorious.org/smack-next/kernel.git
> >
> > James, would you be so kind as to pull for security-testing#next?
> > I think that I have the git tree set up properly, but I'm sure
> > you'll let me know if I've missed something.

Looks like you didn't sign-off the commit (git-commit -s).

Too late to fix it now.

--
James Morris
<jmorris@namei.org>
