Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0KNVzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 16:55:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab0KNVy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 16:54:59 -0500
Message-ID: <4CE05A9E.9090204@redhat.com>
Date: Sun, 14 Nov 2010 22:54:38 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100918 Thunderbird/3.1.4
MIME-Version: 1.0
To: Matt <jackdachef@gmail.com>
CC: Mike Snitzer <snitzer@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
Subject: Re: dm-crypt barrier support is effective
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>	<4CD6B7FA.3050005@redhat.com>	<AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>	<AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>	<20101107194547.GA12521@basil.fritz.box>	<4CD71C8B.1050604@redhat.com>	<20101107230508.GB17592@basil.fritz.box>	<20101108145809.GD29714@redhat.com>	<1289238930-sup-9765@think>	<20101114205925.GA20451@redhat.com> <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
In-Reply-To: <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 10:49 PM, Matt wrote:
> only with the dm-crypt scaling patch I could observe the data-corruption

even with v5 I sent on Friday?

Are you sure that it is not related to some fs problem in 2.6.37-rc1?

If it works on 2.6.36 without problems, it is probably problems somewhere
else (flush/fua conversion was trivial here - DM is still doing full flush
and there are no other changes in code IMHO.)

Milan
