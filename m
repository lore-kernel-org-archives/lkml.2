Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0DTSXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:23:42 -0400
Received: from claw.goop.org ([74.207.240.146]:51255 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab0DTSXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:23:41 -0400
Message-ID: <4BCDF12C.1020702@goop.org>
Date: Tue, 20 Apr 2010 11:23:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>	 <4BCC3A3E.9070909@redhat.com>	 <20100419142158.GD14158@mothafucka.localdomain>	 <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com>
In-Reply-To: <4BCD748E.7080007@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 02:31 AM, Avi Kivity wrote:
> btw, do you want this code in pvclock.c, or shall we keep it kvmclock
> specific?

I think its a pvclock-level fix.  I'd been hoping to avoid having
something like this, but I think its ultimately necessary.

    J
