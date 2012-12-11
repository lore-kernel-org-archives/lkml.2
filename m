Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2LKBTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:19:22 -0500
Received: from vms173021pub.verizon.net ([206.46.173.21]:58938 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2LKBTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:19:21 -0500
MIME-version: 1.0
X-Originating-IP: [96.241.26.26]
In-reply-to: <87d2yiepkp.fsf@rustcorp.com.au>
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net>
 <1353269117-39917-2-git-send-email-pefoley2@verizon.net>
 <20121209165425.GA29331@pobox.suse.cz> <87d2yiepkp.fsf@rustcorp.com.au>
From: Peter Foley <pefoley2@verizon.net>
Date: Mon, 10 Dec 2012 20:18:40 -0500
Message-id: <CAOFdcFP_mzGDkaNyve_Djmy+B-_8u1C62Wt4LizhPTGJv9wBMg@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: silence rule for extra_certificates
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 9, 2012 at 7:08 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Michal Marek <mmarek@suse.cz> writes:
>> Added David and Rusty.
>>
>> On Sun, Nov 18, 2012 at 03:05:14PM -0500, pefoley2@verizon.net wrote:
>>> From: Peter Foley <pefoley2@verizon.net>
>>>
>>> Silence the touch extra_certificates command
>>>
>>> Signed-off-by: Peter Foley <pefoley2@verizon.net>
>>
>> I think we should tell the user that the default empty extra
>> certificates list is being used, in case the user used a wrong filename
>> or similar. How about this?
>
> I prefer this one... Peter?
>
> Thanks,
> Rusty.
>

Looks good to me.

Thanks,

Peter
