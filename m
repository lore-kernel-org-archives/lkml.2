Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0IPJqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab0IPJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:46:07 -0400
Message-ID: <4C91E75B.6010704@redhat.com>
Date: Thu, 16 Sep 2010 11:46:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
References: <20100915185417.GA3924@redhat.com> <20100916090256.GU3008@redhat.com> <20100916091054.GA20864@redhat.com> <20100916092553.GV3008@redhat.com>
In-Reply-To: <20100916092553.GV3008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/16/2010 11:25 AM, Gleb Natapov wrote:
> >
> >  MSI only appeared in rhel6, older guests still use level interrupts.
> So they are already slow for other reasons.
>

Exactly, for example they need to exit to userspace to ack the 
interrupt.  That's far slower than the workqueue.


-- 
error compiling committee.c: too many arguments to function

