Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1HWRgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:36:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48862 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1HWRfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <CADkLE3X82um14wFnisPBtB=PLCX4A9JPVMXmdqdNusfhVAjq2A@mail.gmail.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
	<CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
	<4E53D145.7070207@linux.intel.com>
	<CADkLE3X82um14wFnisPBtB=PLCX4A9JPVMXmdqdNusfhVAjq2A@mail.gmail.com>
Date: Tue, 23 Aug 2011 13:35:53 -0400
Message-ID: <CACqU3MVnskVU4U_iYp6XE32UUf7wXUYJNcu+fyn08WWhKvpmCw@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Arnaud Lacombe <lacombar@gmail.com>
To: Colin Walters <walters@verbum.org>
Cc: Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 23, 2011 at 12:20 PM, Colin Walters <walters@verbum.org> wrote:
> [...]
> I just happen to watch Mozilla bugzilla so I saw that one go by and
> wanted to provide data for the discussion.
>
Just to provide fuel, you can also just do a regular google search for
"strncmp release 2.6". Lots of exploits, but not only.

 - Arnaud

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
