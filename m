Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3AAN2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 08:28:07 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61386 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3AAN2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 08:28:05 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=af5CIMo/LcwhE/oGmlIBzBFfdATRqF9T4efLO6x9hFM= c=1 sm=1
 a=z4rSCaSvssEA:10 a=TPbdJ-YLJ1kA:10 a=FGLzUi7B6sIA:10 a=BLceEmwcHowA:10
 a=kj9zAlcOel0A:10 a=eeMGdU6VVFt2UVJcxx6VzA==:17 a=NEAV23lmAAAA:8
 a=Ct3E01xRAAAA:8 a=VwQbUJbxAAAA:8 a=ufQFP_hAin3rc6Qj8jEA:9
 a=CjuIK1q_8ugA:10 a=utpFWEZwcPkA:10 a=sdf7sEodI2gA:10 a=U62fhAwekXMA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Daniel Phillips <lkml@phunq.net>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tux3 report: New news for the new year
Date: Tue, 01 Jan 2013 05:28:04 -0800
Message-ID: <1492866.3ugQ2fqrP0@mars>
Organization: tux3.org
User-Agent: KMail/4.8.5 (Linux/3.2.0-35-generic-pae; KDE/4.8.5; i686; ; )
In-Reply-To: <201301011406.19983.Martin@lichtvoll.de>
References: <2597526.usDRg4h3X1@mars> <201301011406.19983.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 01, 2013 02:06:19 PM Martin Steigerwald wrote:
> Sounds all good and nice and interesting to test, but where to grab the
> source?
> 
> I found no obvious URL.

Hi Martin,

Sorry about that, I knew I forgot something:

    git://github.com/OGAWAHirofumi/tux3.git

Warning: the recent work is on branch temp-atomic-commit and tends to get 
refactored changeset-wise on a regular basis. This will be merged to master 
pretty soon, and settle down there.

> http://tux3.org/source.html:
> merkaba:/tmp> git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/daniel/linux-tux3.git Cloning
> into 'linux-tux3'...
> fatal: The remote end hung up unexpectedly

I need to do the right incantations to bring the kernel.org tree up again. 
Tux3.org needs some loving. Volunteers welcome.

Regards,

Daniel


