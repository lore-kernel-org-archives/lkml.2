Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2B0ASV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 19:18:21 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:35082 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2B0ASU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 19:18:20 -0500
To: NeilBrown <neilb@suse.de>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "Martin K.Petersen" <martin.petersen@oracle.com>
Subject: Re: MD and rotational attribute
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120220122022.GA7466@x2.net.home>
	<20120227104230.125cb9e2@notabene.brown>
Date: Sun, 26 Feb 2012 19:18:12 -0500
In-Reply-To: <20120227104230.125cb9e2@notabene.brown> (NeilBrown's message of
	"Mon, 27 Feb 2012 10:42:30 +1100")
Message-ID: <yq18vjpuo1n.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F4ACBC8.009C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

Neil,

Neil> (I would say that the name 'rotational' is a bug - the issues here
Neil> is really whether seek is fast or slow is it not??... but no
Neil> matter).

Both the ATA and SCSI specs use the term 'rotational' which I guess is
how we ended up with that name.


Neil> What do you think Martin?  Should QUEUE_FLAG_NONROT move to
Neil> queue_limits much like QUEUE_FLAG_CLUSTER did?

Absolutely. I posted some patches converting both the nonrot and
discard/secure discard queue flags a while back but they didn't go
in. I'll freshen up the kit and resend...

-- 
Martin K. Petersen	Oracle Linux Engineering
