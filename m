Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab1HMHi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 03:38:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:51282 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1HMHiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 03:38:25 -0400
Subject: Re: Missing put_cpu() in arch/ia64/sn/kernel/sn2/sn_hwperf.c?
From: Thomas Meyer <thomas@m3y3r.de>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia@diku.dk>
Date: Sat, 13 Aug 2011 09:37:41 +0200
In-Reply-To: <4E4372DD.6020603@redhat.com>
References: <1312826703.5589.155.camel@localhost.localdomain>
	 <CA+8MBbJDLrNHD0kGdYNv1WPnRh8G1aEY-T3xcS_wMpciTVcy7A@mail.gmail.com>
	 <4E4372DD.6020603@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313221066.16820.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 11.08.2011, 08:12 +0200 schrieb Jes Sorensen:

> I haven't been at SGI for about 2 years now :)
> 

you may want to change this:

$ ./scripts/get_maintainer.pl -f arch/ia64/sn/kernel/sn2/sn_hwperf.c 
Jes Sorensen <jes@sgi.com> (maintainer:SN-IA64 (Itanium)...)
Tony Luck <tony.luck@intel.com> (maintainer:IA64 (Itanium) PL...)
Fenghua Yu <fenghua.yu@intel.com> (maintainer:IA64 (Itanium) PL...)
Arnd Bergmann <arnd@arndb.de> (commit_signer:1/1=100%)
linux-altix@sgi.com (open list:SN-IA64 (Itanium)...)
linux-ia64@vger.kernel.org (open list:SN-IA64 (Itanium)...)
linux-kernel@vger.kernel.org (open list)

with kind regards
thomas



