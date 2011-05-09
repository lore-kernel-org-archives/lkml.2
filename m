Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1EIIvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 04:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab1EIIvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 04:51:39 -0400
Message-ID: <4DC7AB16.7010609@redhat.com>
Date: Mon, 09 May 2011 11:51:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] rcu: provide rcu_virt_note_context_switch() function.
References: <1304515864-17105-1-git-send-email-gleb@redhat.com> <1304515864-17105-2-git-send-email-gleb@redhat.com> <20110504163542.GA2641@linux.vnet.ibm.com>
In-Reply-To: <20110504163542.GA2641@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 07:35 PM, Paul E. McKenney wrote:
> On Wed, May 04, 2011 at 04:31:03PM +0300, Gleb Natapov wrote:
> >  Provide rcu_virt_note_context_switch() for vitalization use to note
> >  quiescent state during guest entry.
>
> Very good, queued on -rcu.
>
> Unless you tell me otherwise, I will assume that you want to carry the
> patch modifying KVM to use this.

Is -rcu a fast-forward-only tree (like tip)?  If so I'll merge it and 
apply patch 2.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

