Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1LARcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:32:06 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:1908 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab1LARcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:32:05 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4ED7BA0C.5060702@broadcom.com>
Date: Thu, 1 Dec 2011 18:31:56 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124
 Thunderbird/8.0
MIME-Version: 1.0
To: "Eric B Munson" <emunson@mgebm.net>
cc: "Jan Kiszka" <jan.kiszka@siemens.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "ryanh@linux.vnet.ibm.com" <ryanh@linux.vnet.ibm.com>,
        "aliguori@us.ibm.com" <aliguori@us.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] Guest stop notification
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
 <4ED79138.60603@siemens.com> <20111201171938.GA8803@mgebm.net>
In-Reply-To: <20111201171938.GA8803@mgebm.net>
X-Enigmail-Version: 1.4a1pre
OpenPGP: id=B5E1A116
X-WSS-ID: 62C964703DS2399447-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 06:19 PM, Eric B Munson wrote:
> On Thu, 01 Dec 2011, Jan Kiszka wrote:
> 
>> On 2011-11-29 22:36, Eric B Munson wrote:
>>> +
>>>  static void cpu_update_state(void *opaque, int running, RunState state)
>>>  {
>>>      CPUState *env = opaque;
>>>  
>>>      if (running) {
>>>          env->tsc_valid = false;
>>> +	kvm_put_guest_paused(env);
>>
>> checkpatch.pl would have asked you to remove this tab.
> 
> Will change to spaces for V2.
> 

Huh. Remove what tab? Indent are always 8-space TAB according
CodingStyle doc:

                Chapter 1: Indentation

Tabs are 8 characters, and thus indentations are also 8 characters.
There are heretic movements that try to make indentations 4 (or even 2!)
characters deep, and that is akin to trying to define the value of PI to
be 3.


Gr. AvS

