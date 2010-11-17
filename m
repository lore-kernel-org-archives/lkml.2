Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993Ab0KQBwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:52:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:60137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab0KQBwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:52:03 -0500
Message-ID: <4CE33527.8090800@infradead.org>
Date: Tue, 16 Nov 2010 23:51:35 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Nicolas Kaiser <nikai@nikai.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: nuvoton: always true expression
References: <20101116211953.238012db@absol.kitzblitz> <20101116215408.GA17140@redhat.com>
In-Reply-To: <20101116215408.GA17140@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-11-2010 19:54, Jarod Wilson escreveu:
> On Tue, Nov 16, 2010 at 09:19:53PM +0100, Nicolas Kaiser wrote:
>> I noticed that the second part of this conditional is always true.
>> Would the intention be to strictly check on both chip_major and
>> chip_minor?
>>
>> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> 
> Hrm, yeah, looks like I screwed that one up. You're correct, the intention
> was to make sure we have a matching chip id high and one or the other of
> the chip id low values.
> 
> Acked-by: Jarod Wilson <jarod@redhat.com>
> 
I wander if it wouldn't be good to print something if the probe fails due to
the wrong chip ID. It may help if someone complain about a different 
revision.

Mauro.
