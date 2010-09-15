Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IOJBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:01:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0IOJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:01:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind1@gmail.com
Subject: Re: [PATCH 2/7] mtd: autoconvert trivial BKL users to private mutex
Date: Wed, 15 Sep 2010 11:01:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, David Woodhouse <David.Woodhouse@intel.com>,
        linux-mtd@lists.infradead.org
References: <1284494022-7346-1-git-send-email-arnd@arndb.de> <1284494022-7346-3-git-send-email-arnd@arndb.de> <1284536526.25181.51.camel@localhost>
In-Reply-To: <1284536526.25181.51.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009151101.01989.arnd@arndb.de>
X-Provags-ID: V02:K0:VqTsT1Z9jlXiFD0CWRyM6Wv3KH4oz2vatmSplqOIwqA
 +B4AVGTZO5ts+o+Gvx61J9a3v/0a38ylqL0UJdXNoryp3eeb/8
 IQ7C5nkqbx65xozoJX6GvlOJnR60/RwMfs3cPZ2Fnw2nip/gJK
 gS3B6yf2tv2MqOi/boEMc2GBYWicrHUVToAtEz2IRAP+7TN34G
 w0eF3lrtOdyN6CkjMwVhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 September 2010, Artem Bityutskiy wrote:
> > Consequently, we can remove the BKL completely,
> > replacing it with a per-file mutex in every case.
> > Using a scripted approach means we can avoid
> > typos.
> > 
> 
> Looks good, are you going to merge them all yourself or you want this to
> go via the mtd tree?

Either way is fine for me. If it goes into the mtd tree, I'll drop
it from my series.

	Arnd
