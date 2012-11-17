Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2KQAkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:40:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47362 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2KQAkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:40:07 -0500
MIME-Version: 1.0
In-Reply-To: <50A66726.8070804@zytor.com>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
	<50A66726.8070804@zytor.com>
Date: Fri, 16 Nov 2012 16:40:06 -0800
X-Google-Sender-Auth: c8Gk-TO87J2FQuWZBWAWX-vItiQ
Message-ID: <CAE9FiQVhkUaYAp06JE1gUpgjW6KSv7+RpHH95q4OxHF5q+431w@mail.gmail.com>
Subject: Re: [PATCH 0/9] x86, boot, 64bit: Add support for loading ramdisk and
 bzImage high
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 8:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:

> How is collecting comments and ACKs for for-x86-mm coming?  I'd like to
> do another review pass today and putting it in -tip if it is in better
> shape.  Otherwise I suspect we'll be looking at 3.9, which is OK, of course.

get three Acks from Stefano.

Konard test -v6 and found one bug, and it is address in -v7.
--- xen domU does not have hole under 4G when 8G ram is configured.

please check updated one with acks and updated log from
    git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

Hope you can put them in tip early for more test coverage.

Thanks

Yinghai
