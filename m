Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab0IOH4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 03:56:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab0IOH4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 03:56:07 -0400
Message-ID: <4C907C0A.7060607@redhat.com>
Date: Wed, 15 Sep 2010 09:55:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Zachary Amsden <zamsden@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C8F3FF3.9080803@redhat.com> <4C8F5125.5060505@siemens.com> <4C8FCDE2.3000202@redhat.com> <4C8FF690.7030107@web.de> <4C9007F2.9020205@redhat.com> <4C905AFC.5020706@web.de>
In-Reply-To: <4C905AFC.5020706@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/15/2010 07:34 AM, Jan Kiszka wrote:
> Do you think kvm-kmod could contribute to this? As I said, I'm on a 34
> kernel, namely SUSE's 2.6.34.4-0.1-desktop. Any feature missing in that
> kernel latest KVM depends for proper tsc/kvm-clock handling? If you have
> any concerns, I could try to run kvm.git natively later on.

In case you aren't aware of it, 'make localmodconfig' is an easy way to 
transition from a distro kernel to a locally built kernel.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

