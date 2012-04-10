Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2DJQLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:11:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57763 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab2DJQL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <4F83F08E.6070304@gmail.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
	<4F1A7854.7010808@gmail.com>
	<1333399194.6431.3.camel@lorien2>
	<CAGXu5jL-QP6LUqc_JY-JevNbrsRUpiP337pfUH4m1CA-+jm_RQ@mail.gmail.com>
	<20120409143345.a7a8c257.akpm@linux-foundation.org>
	<3908561D78D1C84285E8C5FCA982C28F170D020E@ORSMSX104.amr.corp.intel.com>
	<4F83F08E.6070304@gmail.com>
Date: Tue, 10 Apr 2012 09:11:26 -0700
X-Google-Sender-Auth: YgEVC4w-15aSKCADl0vAbZzbDS8
Message-ID: <CAGXu5jLEn-+hnyz5DHxw9uMfN6Uo-=0mXsrhuvJ3WwQKki1nYg@mail.gmail.com>
Subject: Re: [PATCH v5] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 1:34 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> Il 09/04/2012 23:42, Luck, Tony ha scritto:
>
>>> The patch breaks ramoops module unloading.  Tony says there's "no
>>> credible end-user case" for this and Marco promptly provided one,
>>> which was ignored.
>>
>>
>> I'm not sure that I understood Marco's use case. He said:
>>
>>> First of all ramoops was born mainly for debug purpose and
>>> to help the maintainability of a product. I used it in systems
>>> where the uptime (so no reboot) was important. So it can be
>>> very useful for me load the module, gather logs and unload it
>>> for example. A kernel panic is not recoverable so the reboot
>>> is needed but it's not always true for a kernel oops.
>>
>>
>> In the non-crashed oops case ... aren't all the logs you need
>> in /var/log/messages?
>>
>> -Tony
>
>
> Maybe you right, but it could be useful to have a "single log point"
> especially for automatic/semi-automatic log gathering. I'm not sure we can
> *always* read from messages in case of non-crashed oops. Sure, it will be
> possible after a reboot, but if /var was mounted with tmpfs (on embedded
> systems it's possible :)) we have no log.
>
> PS: It's only a brainstorming on all the possible situation :)

Do you feel that this lack of unloading is still a sufficient reason
to NAK the ramoops patch?

-Kees

-- 
Kees Cook
ChromeOS Security
