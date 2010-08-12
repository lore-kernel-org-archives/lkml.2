Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161Ab0HLNtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:49:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62420 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0HLNs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=CW5j16jVrs5QL8cSToIxrSqtTmviJoD0B+2zlGMS6Xl6kqzqNbY7KcGHQZvSuGkEye
         r/Z176jYvlmFnx6sWyLKRoyB1AnWqibvTFyf5KhmxrJUWbd60aagpbVyKnJN292AWIoD
         IcJieTscHTdXBqT+v7V+XRuz3NwYHCtixCbUk=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/2 v2] ARM: Fix gen_nand probe structures contents
Date: Thu, 12 Aug 2010 15:48:28 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, nico@fluxnic.net, kernel@wantstofly.org,
        kernel@pengutronix.de, u.kleine-koenig@pengutronix.de,
        kaloz@openwrt.org, khc@pm.waw.pl, tj@kernel.org, gregkh@suse.de,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem.Bityutskiy@nokia.com, David.Woodhouse@intel.com,
        ralf@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        yakovenkov@gmail.com, w.sang@pengutronix.de
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com> <201008121304.01178.marek.vasut@gmail.com> <AANLkTimuyuNGsTAfJXi7TL4HQH-botNcakse5NHj2fc0@mail.gmail.com>
In-Reply-To: <AANLkTimuyuNGsTAfJXi7TL4HQH-botNcakse5NHj2fc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008121548.28507.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 12. srpna 2010 14:47:06 Mike Frysinger napsal(a):
> On Thu, Aug 12, 2010 at 07:04, Marek Vasut wrote:
> > Dne Čt 12. srpna 2010 05:36:31 Mike Frysinger napsal(a):
> >> On Wed, Aug 11, 2010 at 22:53, Marek Vasut wrote:
> >> > These three platforms didn't properly fill nr_chips in gen_nand
> >> > registration and
> >> 
> >> > therefore depended on gen_nand bug fixed by the following patch:
> >> the Blackfin arch has a mailing list ... no need to pick out people
> > 
> > Hi, that's true, but there's that "scripts/get_maintainer.pl" thing which
> > gave me this list.
> 
> yes, but typically that's a shotgun approach that grabs way more
> people and can easily fall out of date (people no longer
> exist/etc...).  personally, i use it as a fallback when MAINTAINERS
> doesnt cover it.
> -mike

The more eyes on the code, the better :)

Cheers
