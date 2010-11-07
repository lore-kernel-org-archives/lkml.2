Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0KGTpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 14:45:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45284 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0KGTpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 14:45:55 -0500
Date: Sun, 7 Nov 2010 20:45:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Matt <jackdachef@gmail.com>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        htd@fancy-poultry.org
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Message-ID: <20101107194547.GA12521@basil.fritz.box>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
 <4CD6B7FA.3050005@redhat.com>
 <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I read about barrier-problems and data getting to the partition when
> using dm-crypt and several layers so I don't know if that could be
> related

Barriers seem to be totally broken on dm-crypt currently.

But that's probably not your problem. I use the scalability patch
on 2.6.36 and it's very stable. Most likely some mistake 
in the forward port.

-Andi
