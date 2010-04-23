Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0DWVgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:36:06 -0400
Received: from claw.goop.org ([74.207.240.146]:54401 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0DWVgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:36:00 -0400
Message-ID: <4BD212BF.60707@goop.org>
Date: Fri, 23 Apr 2010 14:35:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271675100.1674.818.camel@laptop> <4BCC3A3E.9070909@redhat.com> <20100419142158.GD14158@mothafucka.localdomain> <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com> <4BCDF12C.1020702@goop.org> <4BCDF85C.3000004@redhat.com> <4BCE0399.2010708@goop.org> <20100422131113.GA3364@mothafucka.localdomain> <4BD0FB92.4060301@redhat.com> <4BD169B5.4000409@redhat.com> <4BD211B9.5080707@redhat.com>
In-Reply-To: <4BD211B9.5080707@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 02:31 PM, Zachary Amsden wrote:
> Does lfence / mfence actually serialize?  I thought there was some
> great confusion about that not being the case on all AMD processors,
> and possibly not at all on Intel.
>
> A trap, however is a great way to serialize.
>
> I think, there is no serializing instruction which can be used from
> userspace which does not trap, at least, I don't know one off the top
> of my head.

rsm is not technically privileged... but not quite usable from usermode ;)

    J
