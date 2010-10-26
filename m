Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab0JZRk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175Ab0JZRkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:40:55 -0400
Message-ID: <4CC704E6.2060906@redhat.com>
Date: Tue, 26 Oct 2010 18:42:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Scott Wood <scottwood@freescale.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.37 merge window
References: <4CC434A8.1000903@redhat.com> <20101025114924.6c05160c@udp111988uds.am.freescale.net> <4CC5B764.5030007@redhat.com> <AAAC8548-D406-4CAC-8579-D2B5AAB6AC2C@suse.de>
In-Reply-To: <AAAC8548-D406-4CAC-8579-D2B5AAB6AC2C@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/26/2010 05:55 PM, Alexander Graf wrote:
> >  Alex, if you want them in, please prepare backports for 2.6.36.1.
>
> Why backports for 2.6.36.1 when we're talking about 2.6.27? Most of them fix bugs introduced by the PV framework.

I should have said 2.6.37-rc1, sorry.

-- 
error compiling committee.c: too many arguments to function

