Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1HWNPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:15:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36406 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab1HWNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:15:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CA+55aFwEgp=3F6uH198XuQR0=6Um-Kp+0Wjcm0Xv1WoHRveKXw@mail.gmail.com>
Date: Tue, 23 Aug 2011 09:15:46 -0400
X-Google-Sender-Auth: WxMzwpdo1FGV0Hrn8jTsMVzEUWg
Message-ID: <CADkLE3Ux1gVBR0f1VUNP4JDsnDQPUQ8rJrXqPV7-2kdLW0_CCw@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: Colin Walters <walters@verbum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 2:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> Details. Examples. Name the f&*cking names already. Shame them publicly.

A notable one is that Python now reports "linux3" from sys.platform();
which in turn can break things that were checking sys.platform() ==
"linux2".

https://bugzilla.mozilla.org/show_bug.cgi?id=664564

Seems pretty clear to me though it's a bug in the apps that are using
'==' instead of .startswith().
