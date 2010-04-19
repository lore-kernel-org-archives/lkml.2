Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0DSQTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:19:40 -0400
Received: from claw.goop.org ([74.207.240.146]:39200 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab0DSQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:19:38 -0400
Message-ID: <4BCC829A.6000803@goop.org>
Date: Mon, 19 Apr 2010 09:19:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org> <20100419142624.GE14158@mothafucka.localdomain>
In-Reply-To: <20100419142624.GE14158@mothafucka.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 07:26 AM, Glauber Costa wrote:
>> Is the problem that the tscs are starting out of sync, or that they're
>> drifting relative to each other over time?  Do the problems become worse
>> the longer the uptime?  How large are the offsets we're talking about here?
>>     
> The offsets usually seem pretty small, under a microsecond. So I don't think
> it has anything to do with tscs starting out of sync. Specially because the
> delta-based calculation has the exact purpose of handling that case.
>   

So you think they're drifting out of sync from an initially synced
state?  If so, what would bound the drift?

    J
