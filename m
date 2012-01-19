Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2ASLMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:12:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57190 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2ASLMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:12:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
References: <CAGAKE8_zLr9nrQ_-cXQGzycFo6746t8OzKK6DpCd9tcahyRfPQ@mail.gmail.com>
	<CAGAKE8_wL0GcbjDNWOw4sa8euxZyGDgkdW9EgohpmG48Qk3-nQ@mail.gmail.com>
Date: Thu, 19 Jan 2012 12:12:13 +0100
X-Google-Sender-Auth: AG7ALAdBzPRdQLQOdkefAkDVUy0
Message-ID: <CAO+b5-pZofpN7-e8H+toE98j24fby5u8_Nzfzkz_S31u5wDmwA@mail.gmail.com>
Subject: Re: [Scst-devel] BUG: Process hang when kvm crashed, stacktrace cfs+kvm
From: Bart Van Assche <bvanassche@acm.org>
To: kordex <kordex@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, peterz@infradead.org,
        kvm@vger.kernel.org, avi@redhat.com,
        Mikko Kortelainen <mikko.kortelainen@fail-safe.net>,
        scst-devel <scst-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:54 AM, kordex <kordex@gmail.com> wrote:
> > root@teletex:/usr/src/linux# dmesg
> > +0x12e7/0x1c50
> >  [<ffffffff810dc322>] ? page_add_new_anon_rmap+0x52/0xa0

The above output is truncated - the most interesting part is missing.

Bart.
