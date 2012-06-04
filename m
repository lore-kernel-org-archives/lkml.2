Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2FDE3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:29:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38390 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2FDE3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:29:16 -0400
Message-ID: <4FCC32F6.1010101@landley.net>
Date: Sun, 03 Jun 2012 23:00:54 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Alexander Graf <agraf@suse.de>, KVM <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] Documentation/kvm : Add documentation on Hypercalls
References: <20120531080116.24838.15692.sendpatchset@codeblue.in.ibm.com> <4FC7AE6C.9050106@zytor.com>
In-Reply-To: <4FC7AE6C.9050106@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:46 PM, H. Peter Anvin wrote:
> On 05/31/2012 01:01 AM, Raghavendra K T wrote:
>> +
>> +TODO:
>> +1. more information on input and output needed?
>> +2. Add more detail to purpose of hypercalls.
>>
> 
> 1. definitely, including the hypercall ABI.
> 
> 	-hpa
> 

I was wondering about that. It looks like
Documentation/virtual/kvm/api.txt might cover some of that already in
section 5, but it doesn't look complete...

Also, could I get a 00-INDEX file for this directory explaining what
these individual files are? I think "api.txt" is supposed to be
host-side API for controlling a guest VM (from userspace via ioctls,
looks like), and hypercalls.txt is guest-side API for poking the host.
How someone would write host-side code that _responds_ to a hypercall, I
have no idea.  (It goes in the host kernel?)

Rob



-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
