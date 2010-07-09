Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab0GIUsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:48:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0GIUse convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:48:34 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	<x49fwzsbvga.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilJFQITg7qK5gKJ9Rwt06KA6fvDr7Ed9u7cbwBX@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 09 Jul 2010 16:48:28 -0400
In-Reply-To: <AANLkTilJFQITg7qK5gKJ9Rwt06KA6fvDr7Ed9u7cbwBX@mail.gmail.com>
	(Corrado Zoccolo's message of "Fri, 9 Jul 2010 21:45:22 +0200")
Message-ID: <x49mxu09yar.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

>> I'm not sure what kernel you generated that patch against.  I'm working
>> with 2.6.35-rc3 or later, and your patch does not apply there.

> It's Jens' block/for-2.6.36 tree.

OK.  I'll get back to you on this next week.  My storage is kind of
broken right now.  :(

-Jeff
