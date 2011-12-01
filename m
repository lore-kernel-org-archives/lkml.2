Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1LARfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:35:48 -0500
Received: from david.siemens.de ([192.35.17.14]:18308 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab1LARfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:35:42 -0500
Message-ID: <4ED7BADC.4070809@siemens.com>
Date: Thu, 01 Dec 2011 18:35:24 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Eric B Munson <emunson@mgebm.net>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "ryanh@linux.vnet.ibm.com" <ryanh@linux.vnet.ibm.com>,
        "aliguori@us.ibm.com" <aliguori@us.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] Guest stop notification
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net> <4ED79138.60603@siemens.com> <20111201171938.GA8803@mgebm.net> <4ED7BA0C.5060702@broadcom.com>
In-Reply-To: <4ED7BA0C.5060702@broadcom.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-01 18:31, Arend van Spriel wrote:
> On 12/01/2011 06:19 PM, Eric B Munson wrote:
>> On Thu, 01 Dec 2011, Jan Kiszka wrote:
>>
>>> On 2011-11-29 22:36, Eric B Munson wrote:
>>>> +
>>>>  static void cpu_update_state(void *opaque, int running, RunState state)
>>>>  {
>>>>      CPUState *env = opaque;
>>>>  
>>>>      if (running) {
>>>>          env->tsc_valid = false;
>>>> +	kvm_put_guest_paused(env);
>>>
>>> checkpatch.pl would have asked you to remove this tab.
>>
>> Will change to spaces for V2.
>>
> 
> Huh. Remove what tab? Indent are always 8-space TAB according
> CodingStyle doc:
> 
>                 Chapter 1: Indentation
> 
> Tabs are 8 characters, and thus indentations are also 8 characters.
> There are heretic movements that try to make indentations 4 (or even 2!)
> characters deep, and that is akin to trying to define the value of PI to
> be 3.

Don't worry, this is not kernel code. :) QEMU uses a different coding style.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
