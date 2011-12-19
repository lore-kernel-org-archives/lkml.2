Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1LSNCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:02:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab1LSNCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:02:02 -0500
Message-ID: <4EEF35B5.2090005@redhat.com>
Date: Mon, 19 Dec 2011 15:01:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <4EDF7B0D.4060001@redhat.com> <20111208151929.GA6301@mgebm.net> <4EE8BBF4.8070108@redhat.com> <20111214175844.GD4075@mgebm.net> <4EE9C274.3030603@redhat.com> <20111215185346.GA2829@mgebm.net>
In-Reply-To: <20111215185346.GA2829@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 08:53 PM, Eric B Munson wrote:
> I am working on V7 to incorporate the __this_cpu_and suggestion, would you
> consider that for inclusion and we can continue discussing the need for the
> preemption notification work?  

Okay.

> I think that having a guest complain when the
> host is so loaded that the guest watchdog threads can't make any progress is
> desirable behavior, it may be the only notification that an admin gets that a
> particular host is over loaded.

It's the wrong admin, consider a cloud scenario where the host admin and
guest admin are different people.

Notification on host overload (to initiate migration, say) is a good
idea, but it would be a different mechanism.

-- 
error compiling committee.c: too many arguments to function

