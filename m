Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865Ab2LSNOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:14:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab2LSNO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:14:26 -0500
Message-ID: <50D1BDAD.9060003@draigBrady.com>
Date: Wed, 19 Dec 2012 13:14:21 +0000
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
References: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com> <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com> <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com> <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com> <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com> <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com> <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com> <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com> <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com> <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com> <CALCETrXC9hnBtqHguHh_tXphNutarPYj-nnUA_VAtY9XsfSbpA@mail.gmail.com> <CALCETrWa10sLekJZaaRBJOJW8jnNNWNMy0pVTeu5+OvxS6ZY9A@mail.gmail.com>
In-Reply-To: <CALCETrWa10sLekJZaaRBJOJW8jnNNWNMy0pVTeu5+OvxS6ZY9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 06:29 PM, Andy Lutomirski wrote:
> On Sat, Dec 8, 2012 at 3:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> I just tried to search to find actual uses of pI/fI.  Here's what I found:
>
> I downloaded all the Fedora spec files and searched for file
> capabilities.  Assuming I didn't mess up, here's what I found:

Just pointing out a handy online search tool
for this sort of thing.

http://searchco.de/?q=%25caps+url:fedora+ext:spec

thanks,
Pǽdraig.
