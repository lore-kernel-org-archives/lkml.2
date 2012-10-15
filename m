Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2JOS2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:28:21 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:6187 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754375Ab2JOS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:28:20 -0400
Message-ID: <1350325693.2819.19.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v6 06/10] glge driver: rename internal SEM_SET macro to
 SEM_INIT
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: <akpm@linux-foundation.org>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <dhowells@redhat.com>,
        <manfred@colorfullife.com>, <hughd@google.com>, <jmorris@namei.org>,
        <mtk.manpages@gmail.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <paulmck@linux.vnet.ibm.com>, <sds@tycho.nsa.gov>, <devel@openvz.org>,
        <a.p.zijlstra@chello.nl>, <cmetcalf@tilera.com>,
        <linux-driver@qlogic.com>, <ron.mercer@qlogic.com>,
        <viro@zeniv.linux.org.uk>, <eparis@parisplace.org>,
        <tglx@linutronix.de>, <jitendra.kalsaria@qlogic.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <ebiederm@xmission.com>,
        <casey@schaufler-ca.com>
Date: Mon, 15 Oct 2012 19:28:13 +0100
In-Reply-To: <20121015160006.28348.79520.stgit@localhost.localdomain>
References: <20121015155800.28348.23561.stgit@localhost.localdomain>
	 <20121015160006.28348.79520.stgit@localhost.localdomain>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 20:00 +0400, Stanislav Kinsbursky wrote:
> The reason for shit patch is that SET_SET is desired to be a part of new part
> of API of IPC sys_semctl() system call.
[...]

Two spelling errors above. :-)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

