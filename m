Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0ELSFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:05:40 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:61927 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab0ELSFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:05:38 -0400
Message-ID: <4BEAED98.30502@nortel.com>
Date: Wed, 12 May 2010 12:04:08 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Kosin <jkosin@intcomgrp.com>
CC: Dhaval Giani <dhaval.giani@gmail.com>, Jan Safranek <jsafrane@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       menage@google.com, balbir@linux.vnet.ibm.com, lennart@poettering.net,
       tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>	 <1273674048.1626.117.camel@laptop> <4BEABDF8.40206@redhat.com>	 <4BEAE7A1.2010001@intcomgrp.com> <AANLkTikEyJ8q9GkpyZo0OUY4MLM_soWEviiBG2R6H-mY@mail.gmail.com> <4BEAEC2A.6090306@intcomgrp.com>
In-Reply-To: <4BEAEC2A.6090306@intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2010 18:05:33.0832 (UTC) FILETIME=[B7554880:01CAF1FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 11:58 AM, James Kosin wrote:

> Thanks for clearing that up.
> It looks like they are not under the control of the programmer on
> purpose.  It is not outlined in the description of how to use this feature.
> The tasks have to be added separately by an administrator that is
> operating the system to tune performance and to provide resources where
> most needed.

Depending on the type of system, they may or may not be under the
control of the programmer. In an embedded environment, the programmer is
the administrator and generally has control over how the groups are set
up. On a more generic time-sharing system it's likely that the
individual programmer won't have control over the groups.

Something I haven't tried is whether or not it's possible to set
ownership/permissions on subtrees within the cgroup hierarchy to allow
unprivileged users/groups to control their own tasks (basically letting
them prioritize their own jobs without being able to affect anything
else).  Does anyone know if this sort of thing is possible?

Chris
