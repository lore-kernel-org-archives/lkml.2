Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab1JBKWO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 06:22:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab1JBKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 06:22:07 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyci1PB9Y_BSqWnQKSSfcCrbJud+q1Z8Cdquo7hXJZaMw@mail.gmail.com>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
	<CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
	<CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
	<CA+55aFyci1PB9Y_BSqWnQKSSfcCrbJud+q1Z8Cdquo7hXJZaMw@mail.gmail.com>
Date: Sun, 2 Oct 2011 12:22:07 +0200
Message-ID: <CAA879TMgMm4u6kDFahXqCHAFyvDc_hTt+Q93tdSdHKnAcUaMTw@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
From: Guillaume Chazarain <guichaz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 2:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I don't see why you ask for it. What could possibly be a valid use-case?

Right, kbyte granularity is enough. And that's consistent with
/proc/vmstat, which nobody is complaining about.

-- 
Guillaume
