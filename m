Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2DBPbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:31:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49050 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2DBPbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:31:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAF8ieYVORFvYM3yHVgJD+E9p99nLLWK+uBkdH=4WkdpXm=6bGg@mail.gmail.com>
References: <1333195133-4944-1-git-send-email-consul.kautuk@gmail.com>
	<CAF8ieYX0h2zaJN7ns345uXwZWoa3hzEZAJ331eJOTX4_pj-ZdQ@mail.gmail.com>
	<CAF8ieYVORFvYM3yHVgJD+E9p99nLLWK+uBkdH=4WkdpXm=6bGg@mail.gmail.com>
Date: Mon, 2 Apr 2012 21:01:35 +0530
Message-ID: <CAFPAmTRW7ptY53zO1CoH7JvG4idKPBgRViV5Af86AMfNT_+Ghg@mail.gmail.com>
Subject: Re: [PATCH 01/19 v2] avr32/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 8:28 AM, Håvard Skinnemoen <hskinnemoen@gmail.com> wrote:
> On Sun, Apr 1, 2012 at 7:08 PM, Håvard Skinnemoen <hskinnemoen@gmail.com> wrote:
>> Ug...the avr32 arch is in a terrible state. Someone appears to have
>> removed the atmel_nand driver...
>
> Never mind; Paul Gortmaker already fixed it :)
>

Great.

> Your patch doesn't cause anything to blow up in any obvious way, so it
> should be good to go as far as I can tell (although it would be great
> if you could do that tiny cleanup I mentioned).

Ok, Ill make that change and resend v2.1 of this to the mailing list.
Can you please ACK that if you find it to be okay ?
Thanks !

>
> Havard
