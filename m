Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab1CYUtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:49:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33859 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab1CYUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:49:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyril Hrubis <metan@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: reboot/kexec in 2.6.38
References: <20110317064523.GA1995@ucw.cz>
	<AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
	<20110322133034.GA15475@atrey.karlin.mff.cuni.cz>
Date: Fri, 25 Mar 2011 13:49:35 -0700
In-Reply-To: <20110322133034.GA15475@atrey.karlin.mff.cuni.cz> (Cyril Hrubis's
	message of "Tue, 22 Mar 2011 14:30:34 +0100")
Message-ID: <m1bp0zylgg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/E3NBfbDhMsxpo+2P2cGJCoTB4/o1wyq4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Hrubis <metan@ucw.cz> writes:

> Hi!
>> I think it's config issue. Never heard of this.
>
> I've just compiled and booted 2.6.38. The kernel boots without problems when
> flashed in. But I've had no success with kexec, the last lines I see are:
>
> Starting new kernel

Enable early_printk to a serial port if you can.

There is definitely an issue in 2.6.38 where kdump doesn't work, that
right now looks like a memblock issue.

Eric
