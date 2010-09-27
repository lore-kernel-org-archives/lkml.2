Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab0I0GKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:10:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42265 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab0I0GKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hX3ckoVDsoMj8/aSDYalkdAYfjcNPUQXXIRT221bEvPH2B0+QxbRPlvGsb+7KCsn60
         5yw2e5fqNdGtyAulYIBSeC3IE/n1MxWa1Sb037UbpoSc2eBl66QPgQmZNBPDby4qlcSA
         CykAJOjQEGFuPC/lyv36Ezs4cbMqFy+j8eFDk=
Subject: Re: [PATCH v6] Gigabit Ethernet driver of Topcliff PCH
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        John Linn <john.linn@xilinx.com>, Ralf Baechle <ralf@linux-mips.org>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Maxime Bizon <mbizon@freebox.fr>, Greg Rose <gregory.v.rose@intel.com>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        MeeGo <meego-dev@meego.com>
In-Reply-To: <4CA03198.8080802@dsn.okisemi.com>
References: <4CA03198.8080802@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 08:10:00 +0200
Message-ID: <1285567800.2357.565.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 27 septembre 2010 à 14:54 +0900, Masayuki Ohtake a écrit :
> Gigabit Ethernet driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. 
> Topcliff PCH has Gigabit Ethernet I/F. Using this I/F, it is able to 
> access system devices connected to Gigabit Ethernet.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---

Hmm, what is going on ?

David already put your driver in net-next-2.6

http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=commit;h=77555ee7228234257957fd54daa0b69178906320

If you want to make changes, you have to send diffs now, not the full
version.

Thanks


