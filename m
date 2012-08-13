Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2HMKfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:35:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:52128 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2HMKfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:35:45 -0400
Message-ID: <5028D86E.9040907@parallels.com>
Date: Mon, 13 Aug 2012 14:35:26 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "arnd@arndb.de" <arnd@arndb.de>, "hughd@google.com" <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "yeohc@au1.ibm.com" <yeohc@au1.ibm.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "devel@openvz.org" <devel@openvz.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>
Subject: Re: [PATCH v3 08/10] IPC: message queue copy feature introduced
References: <20120810141517.12411.83398.stgit@localhost6.localdomain6> <20120810142602.12411.63440.stgit@localhost6.localdomain6> <CALgW_8X_gSDG0GdoU4WShohsyhdXOXTh8o9KsYPFtnkzcJXpCQ@mail.gmail.com> <50265EC9.5020602@parallels.com> <CALgW_8VX2pnhohrm6kNA4Ps4COpxVcPV=jNFp+s9O6yj64Vpzw@mail.gmail.com>
In-Reply-To: <CALgW_8VX2pnhohrm6kNA4Ps4COpxVcPV=jNFp+s9O6yj64Vpzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.08.2012 13:48, Manfred Spraul пишет:
> I would keep it simple - unless there is a clear use case where "peek
> by id" is useful.
>
> Or - since MSG_COPY is linux specific anyway:
> What about storing the number of the message that should be returned in *msgp?
> Store it as "int64", just to avoid any 32/64 bit issues.

Sounds reasonable. But, probably, mtype suit better for message number.
I'll update.

-- 
Best regards,
Stanislav Kinsbursky
