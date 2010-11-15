Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0KOImR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:42:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab0KOImP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:42:15 -0500
Message-ID: <4CE0F24F.6070608@redhat.com>
Date: Mon, 15 Nov 2010 09:41:51 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100918 Thunderbird/3.1.4
MIME-Version: 1.0
To: Heinz Diehl <htd@fritha.org>
CC: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
Subject: Re: dm-crypt barrier support is effective
References: <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com> <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com> <20101107194547.GA12521@basil.fritz.box> <4CD71C8B.1050604@redhat.com> <20101107230508.GB17592@basil.fritz.box> <20101108145809.GD29714@redhat.com> <1289238930-sup-9765@think> <20101114205925.GA20451@redhat.com> <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com> <4CE05A9E.9090204@redhat.com> <20101115072545.GA7492@fritha.org>
In-Reply-To: <20101115072545.GA7492@fritha.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 08:25 AM, Heinz Diehl wrote:
> On 15.11.2010, Milan Broz wrote: 
> 
> drivers/md/dm-crypt.c: In function crypt_ctr':
> drivers/md/dm-crypt.c:1408: error: WQ_MEM_RECLAIM' undeclared (first use in this function)
> drivers/md/dm-crypt.c:1408: error: (Each undeclared identifier is reported only once
> drivers/md/dm-crypt.c:1408: error: for each function it appears in.)

It should be enough to just replace WQ_MEM_RECLAIM to WQ_RESCUER for 2.6.36.
(that define is new in 2.6.37)

Milan
