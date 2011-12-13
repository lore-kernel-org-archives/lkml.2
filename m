Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1LMUB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:01:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:39527 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583Ab1LMUBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:01:25 -0500
Message-ID: <1323806421.9082.53.camel@twins>
Subject: Re: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, pv-drivers@vmware.com,
        Andrei Warkentin <andreiw@vmware.com>, stable@kernel.org
In-Reply-To: <1323712953-13636-1-git-send-email-dtor@vmware.com>
References: <1323712953-13636-1-git-send-email-dtor@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Dec 2011 21:00:21 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 10:02 -0800, Dmitry Torokhov wrote:
> 1 is a power of two, therefore rounddown_pow_of_two(1) should return 1.

x^0 = 1
x^1 = x

Seems to me 0 was the right answer, no?


