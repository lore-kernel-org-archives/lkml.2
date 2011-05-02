Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1EBD0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 23:26:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51166 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1EBD0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 23:26:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/69] faster tree-based sysctl implementation
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
	<m1zkn68mpk.fsf@fess.ebiederm.org>
	<BANLkTi=NcpPQUGkR=pbOMPfMkyL7LiBeoA@mail.gmail.com>
	<m1r58i2g02.fsf@fess.ebiederm.org>
	<BANLkTi=JzmOm+Sm+xnY+rT-r8EwxQXO-xw@mail.gmail.com>
Date: Sun, 01 May 2011 20:26:37 -0700
In-Reply-To: <BANLkTi=JzmOm+Sm+xnY+rT-r8EwxQXO-xw@mail.gmail.com> (Lucian
	Adrian Grijincu's message of "Mon, 2 May 2011 01:34:19 +0200")
Message-ID: <m139kxye8i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19VDH/9N6fUlg+wVWj4Pgzw0P/WWrnoTg0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

>> For long term maintainability and comprehensibility I think moving
>> sysctl in the direction of a normal filesystem makes a lot of sense.
>
> Ok, I agree that a later redesign of sysctl would suffer if there
> would be a mess regarding registration/unregistration of directories
> and no ownership information/enforcement. I'll see how this can be
> addressed in the next respin of this series.

Thanks.

Eric

