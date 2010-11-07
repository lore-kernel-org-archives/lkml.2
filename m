Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0KGVjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:39:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0KGVjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:39:40 -0500
Message-ID: <4CD71C8B.1050604@redhat.com>
Date: Sun, 07 Nov 2010 22:39:23 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100918 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Matt <jackdachef@gmail.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com, htd@fancy-poultry.org
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com> <4CD6B7FA.3050005@redhat.com> <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com> <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com> <20101107194547.GA12521@basil.fritz.box>
In-Reply-To: <20101107194547.GA12521@basil.fritz.box>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2010 08:45 PM, Andi Kleen wrote:
>> I read about barrier-problems and data getting to the partition when
>> using dm-crypt and several layers so I don't know if that could be
>> related
> 
> Barriers seem to be totally broken on dm-crypt currently.

Can you explain it?

Barriers/flush change should work, if it is broken, it is not only dm-crypt.
(dm-crypt simply relies on dm-core implementation, when barrier/flush
request come to dmcrypt, all previous IO must be already finished).

Milan
