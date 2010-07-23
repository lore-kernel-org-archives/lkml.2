Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0GWMdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:33:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49638 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0GWMdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:33:42 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Hill" <hilld@binarystorm.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug #16173] After uncompressing the kernel, at boot time, the server hangs.
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
	<tneGvaw1wLL.A.zlC.h5XSMB@chimera>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 23 Jul 2010 05:33:37 -0700
In-Reply-To: <tneGvaw1wLL.A.zlC.h5XSMB@chimera> (Rafael J. Wysocki's message of "Fri\, 23 Jul 2010 13\:42\:35 +0200 \(CEST\)")
Message-ID: <m1ocdys7ha.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).

This one is a mystery.  I have tried and failed to reproduce this on a similar
hardware configuration so I am at a loss as to where to look next to understand
this bug.

Eric



> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16173
> Subject		: After uncompressing the kernel, at boot time, the server hangs.
> Submitter	: David Hill <hilld@binarystorm.net>
> Date		: 2010-06-09 23:25 (45 days old)
> First-Bad-Commit: http://git.kernel.org/linus/cf7500c0ea133d66f8449d86392d83f840102632
> Handled-By	: Eric W. Biederman <ebiederm@xmission.com>
