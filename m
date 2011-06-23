Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab1FWNnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:43:40 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:42599 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358Ab1FWNni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:43:38 -0400
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
 Vpid:)
From: Greg Kurz <gkurz@fr.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, akpm@linux-foundation.org,
        containers@lists.osdl.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com, daniel.lezcano@free.fr, oleg@redhat.com,
        xemul@openvz.org, Cedric Le Goater <clg@vnet.ibm.com>
In-Reply-To: <m1oc1pl6t1.fsf@fess.ebiederm.org>
References: <20110615145527.4016.70157.stgit@bahia.local>
	 <BANLkTimSC_OSrbekhM=wd2Gie4np3Q4F5A@mail.gmail.com>
	 <1308570316.8230.140.camel@bahia.local>
	 <BANLkTiknqo0iKry7mjq+mc4iOWj_A_mrrw@mail.gmail.com>
	 <m1ei2o9l7a.fsf@fess.ebiederm.org>	<1308756565.2959.65.camel@bahia.local>
	 <m1oc1pl6t1.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 15:43:05 +0200
Message-ID: <1308836585.2959.89.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 17:39 -0700, Eric W. Biederman wrote:
> I was suggesting implement rt_sigqueueinfo_fd as a proc file instead.
> 
> Getting a file descriptor api one way or another for delivering signals
> sounds nice in principle.  I don't know if it is useful enough to
> justify the cost of implementing and supporting it.
> 

That's my concern: it will take some time to work it out and push it. In
comparison, ActivePid: has no support overhead and is enough for
userland code to relate pids betwen parent and child namespaces.
Mitigating the race with pids is cool but it is another topic IMHO.

Thanks.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

