Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0DIRnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:43:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab0DIRnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:43:51 -0400
Message-ID: <4BBF674C.30201@redhat.com>
Date: Fri, 09 Apr 2010 20:43:40 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tom Lyon <pugs@lyon-about.com>
CC: Greg KH <gregkh@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged
 processes
References: <201003311708.38961.pugs@lyon-about.com> <20100402170515.GA32579@suse.de> <4BBEFA3B.8070609@redhat.com> <201004090934.16891.pugs@lyon-about.com>
In-Reply-To: <201004090934.16891.pugs@lyon-about.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 07:34 PM, Tom Lyon wrote:
>> - access to all config space, but BARs must be translated so userspace
>> cannot attack the host
>>      
> Please elaborate. All of PCI config? All of PCIe config? Seems like a huge mess.
>    

Yes.  Anything a guest's device driver may want to access.

> The 'check' items are already done, not fully tested; probably available next week.
> Can we leave the others for future patches? Please?

Hey, I was expecting we'd have to do all of this.  The requirements list 
was to get the uio maintainers confirmation that this is going in an 
acceptable direction.

We can definitely proceed incrementally.

> And I definitely need help with
> the PCI config stuff.
>    

Sure.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

