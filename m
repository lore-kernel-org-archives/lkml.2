Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0IBNPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:15:44 -0400
Received: from borg.medozas.de ([188.40.89.202]:51923 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0IBNPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:15:43 -0400
Date: Thu, 2 Sep 2010 15:15:37 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
In-Reply-To: <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene>
 <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2010-08-30 12:18, Miklos Szeredi wrote:
>
>> My comment about set-theory unions being commutative set me thinking.  I
>> really don't think "union" is the right name for this thing.  There is
>> nothing about it which really fits that proper definition of a union.
>
>We could call it overlayfs.  People learn new names quickly :)

There is a much larger issue that you should be very well aware about —

"The name wanted to be a clever acronym for "Filesystem in
USErspace", but it turned out to be an unfortunate choice. The author
has since vowed never to name a project after a common term, not even
anything found more than a handful of times on Google."

overlayfs already exists. Right next to fuse on sourceforge...


Oh and I what I like to see is support for multiple readonly branches :)
