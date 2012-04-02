Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2DBC6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 22:58:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59098 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2DBC6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 22:58:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAF8ieYX0h2zaJN7ns345uXwZWoa3hzEZAJ331eJOTX4_pj-ZdQ@mail.gmail.com>
References: <1333195133-4944-1-git-send-email-consul.kautuk@gmail.com>
	<CAF8ieYX0h2zaJN7ns345uXwZWoa3hzEZAJ331eJOTX4_pj-ZdQ@mail.gmail.com>
Date: Sun, 1 Apr 2012 19:58:21 -0700
Message-ID: <CAF8ieYVORFvYM3yHVgJD+E9p99nLLWK+uBkdH=4WkdpXm=6bGg@mail.gmail.com>
Subject: Re: [PATCH 01/19 v2] avr32/mm/fault.c: Port OOM changes to do_page_fault
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 7:08 PM, Håvard Skinnemoen <hskinnemoen@gmail.com> wrote:
> Ug...the avr32 arch is in a terrible state. Someone appears to have
> removed the atmel_nand driver...

Never mind; Paul Gortmaker already fixed it :)

Your patch doesn't cause anything to blow up in any obvious way, so it
should be good to go as far as I can tell (although it would be great
if you could do that tiny cleanup I mentioned).

Havard
