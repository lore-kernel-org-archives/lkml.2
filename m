Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2GBPwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:52:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2GBPww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:52:52 -0400
Message-ID: <4FF1C3CE.3020404@redhat.com>
Date: Mon, 02 Jul 2012 18:52:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com, cornelia.huck@de.ibm.com
Subject: Re: [PATCH v3 0/3] kvm: KVM_IRQFD cleanup, docs, sanitize flags
References: <20120629154940.30535.17132.stgit@bling.home> <1341244311.1207.449.camel@bling.home>
In-Reply-To: <1341244311.1207.449.camel@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 06:51 PM, Alex Williamson wrote:
> On Fri, 2012-06-29 at 09:56 -0600, Alex Williamson wrote:
>> Before we start fiddling with what we can and can't add to KVM_IRQFD
>> we need to figure out if anyone has been sloppy in their use of the
>> ioctl flags.  This series has a minor cleanup to pass the struct
>> kvm_irqfd to seup functions rather than individual parameters, making
>> it more consistent with ioeventfd, adds API documentation for this
>> ioctl, and sanitizes the flags.  If anyone screams, we may have to
>> revert this last patch.  Thanks,
> 
> Avi, what do you think about trying to get this in for 3.5 to test
> whether we break anyone?  Then we can aim for 3.6 for level irqfd &
> eoifd support.

Makes sense.  Marcelo?


-- 
error compiling committee.c: too many arguments to function


