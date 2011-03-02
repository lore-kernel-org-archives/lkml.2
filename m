Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1CBLmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:42:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59401 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab1CBLmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:42:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/7] Final BKL removal, take 2
Date: Wed, 2 Mar 2011 12:42:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>, linux-fsdevel@vger.kernel.org,
        linux-x25@vger.kernel.org, Max Vozeler <max@vozeler.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        netdev@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        Nick Piggin <npiggin@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de> <20110302045923.GA28214@suse.de> <4D6E2ABF.5040500@redhat.com>
In-Reply-To: <4D6E2ABF.5040500@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103021242.12699.arnd@arndb.de>
X-Provags-ID: V02:K0:xgCn8Uyd2380lE32QzmAb2ilcL6ngd6OBd1ruy+XF6v
 qjrrjVhlkiq/P33y9RQGy91jnqC7KVBzHfSArTy8CN/zLd9KOV
 i3TQkJmvOHmfdlZukye3Y9E+Sbu1xj9KPJJlqrh4aHMSsGCFzh
 hp8AlZ0VBwJkBJuoA+Bfn3v0BdU22GMEe6trqcfFNxl4FqJ+h5
 JPTmi8icX8tlqBAvs32lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011, Mauro Carvalho Chehab wrote:
> It is probably better to queue the staging/cx25821 patch via my tree, as this is one
> of those staging files that it is handled via media tree. So, if it is ok
> for you both, I'll get patch 2/7.

Fine with me.

Thanks,

	Arnd
