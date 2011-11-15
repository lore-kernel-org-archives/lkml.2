Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1KONuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:50:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55297 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab1KONuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:50:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUCE5fB0KGcmmXkpqVnasqpx0cSt01qhXO1CNVRJcSWeA@mail.gmail.com>
References: <1318376345.2050.20.camel@boudreau>
	<j9r5m5$b18$1@dough.gmane.org>
	<1321296650.2066.17.camel@boudreau>
	<4EC21F67.10905@redhat.com>
	<CAM_iQpUCE5fB0KGcmmXkpqVnasqpx0cSt01qhXO1CNVRJcSWeA@mail.gmail.com>
Date: Tue, 15 Nov 2011 21:50:03 +0800
Message-ID: <CAM_iQpWMGOKkDFWO-dw6GZ5B0knQ2yn3rHD0RvReK-2_NDjS-A@mail.gmail.com>
Subject: Re: Crash during vmcore_init
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Dave Young <dyoung@redhat.com>
Cc: tim@edgecast.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 9:47 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
> I bet Tim is using i386 machine, and on i386 we have,
>
> kexec/arch/i386/crashdump-x86.c
>

Er, it is x86_64... but they share the same source file...
