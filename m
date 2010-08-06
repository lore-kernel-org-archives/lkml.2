Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934961Ab0HFOx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:53:27 -0400
Received: from claw.goop.org ([74.207.240.146]:58234 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759702Ab0HFOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:53:25 -0400
Message-ID: <4C5C21E3.1020004@goop.org>
Date: Fri, 06 Aug 2010 07:53:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Xen-devel <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Nick Piggin <npiggin@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 02/12] x86/ticketlock: convert spin loop to C
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com> <cf01e01095f802dc5082e82a8e96c84903e929a6.1279328276.git.jeremy.fitzhardinge@citrix.com> <1280761639.1923.213.camel@laptop> <4C56E1A1.6020005@goop.org> <4C5C1F80020000780000EA6D@vpn.id2.novell.com>
In-Reply-To: <4C5C1F80020000780000EA6D@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/06/2010 05:43 AM, Jan Beulich wrote:
> You certainly mean "the compiler currently treats this as being:" - I
> don't think there's a guarantee it'll always be doing so.
>
>> 	for (;;) {
>> 		if (inc.tickets.head == inc.tickets.tail)
>> 			goto out;
>> 		...
>> 	}
>> out:	barrier();
>> }
>>
>> (Which would probably be a reasonable way to clarify the code.)
> I therefore think it needs to be written this way.

Agreed.

     J
