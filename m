Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966386Ab2ERSwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:52:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46858 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070Ab2ERSwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:52:53 -0400
Message-ID: <4FB69A75.30507@zytor.com>
Date: Fri, 18 May 2012 11:52:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
References: <4FB67146.9080804@zytor.com> <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com> <CAMe9rOp-UoQFBvvorZA8-jBXk5JobkVa+trUH7ihHLxNyqMuWw@mail.gmail.com> <4FB67697.50904@zytor.com> <CAMe9rOqAJGemCiAebtYczqvV62J_cyZcZDDtkFZyLHPKZg1xqQ@mail.gmail.com> <4FB67CD6.8040103@zytor.com> <CAMe9rOpUoj_1TM0NOqVX31aHEez3_i9v6f7_zkGeM8SZ+XDxyQ@mail.gmail.com> <4FB67E20.6080300@zytor.com> <20120518184121.GA3371@kroah.com>
In-Reply-To: <20120518184121.GA3371@kroah.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 11:41 AM, Greg KH wrote:
> On Fri, May 18, 2012 at 09:51:44AM -0700, H. Peter Anvin wrote:
>> On 05/18/2012 09:50 AM, H.J. Lu wrote:
>>>
>>> A small testcase:
>>>
>>
>> Right, but we can equally well just let the postprocessing tool throw an
>> error.
> 
> That would probably be the best thing to do right now, and we can
> backport that to the stable kernel releases also to ensure they work
> properly.
> 

So the question is: do you want to simply take the patches from the
trampoline branch (which are reasonably tested) or do a minimal backport
which only throws an error (which would not be)?

	-hpa

