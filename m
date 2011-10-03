Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1JCAnq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 20:43:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44436 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1JCAnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 20:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <20111002225434.GA22333@ericsson.com>
References: <4E8655CD.90107@zytor.com>
	<201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com>
	<201110021354.57995.rjw@sisk.pl>
	<4E88AF15.7000503@xenotime.net>
	<20111002225434.GA22333@ericsson.com>
Date: Sun, 2 Oct 2011 20:43:41 -0400
Message-ID: <CABEuxAPA0QAcy+2dLG4gfi6yiK8_vvQhHy0m6C1=RGFMHqvkOQ@mail.gmail.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
From: Lee Mathers <wwbbs2008@gmail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can us non kernel quality developers assist in making this a
reality.   I have extensive pki experience and while my certifications
are stale I still consider myself an expert in internet privacy and
security. Which are !=
I have been waiting for a long time for a series of incidents like
this to occur to linux what surprises me is the magnitude of the
impact to the community.  However to wear out an expression further
what ever does not kill you makes you stronger. I Apologize for the
for formating using gmail from a blackberry.  Which just had it's
security cracked if it makes you feel better.  But in reality this is
such has a very low impact on user security it's not like
apt-get/aptitude, yum or rpm/update are pulling the latest stuff from
kernel.org.  The impact here is felt most by the developers of the
kernel it self.  I don't know about you but I don't download new src
often I just continually apply vetted patches to both my applications
and often the kernel it self.  That is one of the simplest defenses
against a large scale attack that you can not do with src you can not
read/compile is change it so signature based attacks do not work.
Let's face it a custom compiled kernel/application is a significantly
lower security risk than a distribution kernel. (Considering the
person compiling the kernel is following a minimalist approach to
supporting his environment and is knowledgeable of GNU/Linux
development.

On 10/2/11, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> On Sun, Oct 02, 2011 at 02:36:05PM -0400, Randy Dunlap wrote:
>> On 10/02/11 04:54, Rafael J. Wysocki wrote:
>> > On Sunday, October 02, 2011, H. Peter Anvin wrote:
>> >> On 10/01/2011 06:04 PM, Rafael J. Wysocki wrote:
>> >>>
>> >>> OK, I'm taking this as "5 years is fine by us". :-)
>> >>>
>> >>> And the recommended procedure for rotating keys seems to be (1)
>> >>> generate
>> >>> a new key and (2) make as many people as you can sign it before the
>> >>> old
>> >>> one expires, right?
>> >>>
>> >>
>> >> (3) revoke the old key with a status code of "no longer in use", or
>> >> just
>> >> let it expire.
>> >>
>> >>>> Some people have decided to opt for an unlimited key, but that
>> >>>> *requires* that you have a way to revoke the old key, which is why we
>> >>>> are considering a key revocation escrow service.
>> >>>
>> >>> That service will be necessary anyway in case some keys are lost or
>> >>> compromised.
>> >>>
>> >>> I wonder what the procedure of restoring kernel.org access in case one
>> >>> has lost keys is supposed to be?
>> >>
>> >> Get a new key and get it re-signed.
>> >
>> > Hmm.  That doesn't seem very practical if someone doesn't live close
>> > to any other core kernel developers.
>> >
>> > What number of signatures on the key will be regarded as sufficient?
>> >
>> >> We can work out specific details at KS.
>> >
>> > Well, the KS is going to be busy time this year I suppose. :-)
>> >
>> > What about people who haven't been invited to the KS?
>>
>> They (we) should start building a web of trust with local key signings.
>> I'm already working on that in Portland, Oregon.
>>
> Anyone in Silicon Valley looking for key signings, please get in touch.
>
> Thanks,
> Guenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
