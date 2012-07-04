Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933819Ab2GDKHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:07:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36570 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2GDKHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:07:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120703134120.dc89c7ae.akpm@linux-foundation.org>
References: <1341035970-20490-1-git-send-email-akinobu.mita@gmail.com>
	<20120703134120.dc89c7ae.akpm@linux-foundation.org>
Date: Wed, 4 Jul 2012 19:07:18 +0900
Message-ID: <CAC5umyhLEp_T1BF6LRNLBMcO-QEE6_hTLL1PAd=65yYRBg3rpQ@mail.gmail.com>
Subject: Re: [PATCH -v5 0/6] notifier error injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        Greg KH <greg@kroah.com>, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/4 Andrew Morton <akpm@linux-foundation.org>:
> On Sat, 30 Jun 2012 14:59:24 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> This provides kernel modules that can be used to test the error handling
>> of notifier call chain failures by injecting artifical errors to the
>> following notifier chain callbacks.
>
> No updates to Documentation/fault-injection/?

Thanks for the remainder.
I'll prepare to add a document to it.
