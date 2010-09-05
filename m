Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0IEI0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0IEI0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:26:40 -0400
Message-ID: <4C835434.8080702@redhat.com>
Date: Sun, 05 Sep 2010 11:26:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Glauber Costa <glommer@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping] Revert getnsboottime() kernel API
References: <1283320624-31262-1-git-send-email-zamsden@redhat.com> <4C81C058.9050105@redhat.com>
In-Reply-To: <4C81C058.9050105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/04/2010 06:43 AM, Zachary Amsden wrote:
> Never got any feedback on this.  I don't really have a strong opinion 
> on it either way, but I'll need to know which way to go with my 
> rebased patches. 

Applied it, thanks.

> Also nice if we can avoid polluting upstream with unnecessary changes.

Yes.

>
> I believe it would suffice also to revert these two commits:
>
> 2616ac0be4b12bf31cfe8880a5b21c5a2da7d150
> b8a578a03d18fab78ea1f79886e32c90f1d071a1
>

This is what I did.

-- 
error compiling committee.c: too many arguments to function

