Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab3AISpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:45:32 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58620 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3AISpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:45:31 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 13:45:31 EST
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUxxjZmd3C33_ujSeL1EjcKHHSoGusQwfBD+Zd=cwCDZA@mail.gmail.com>
References: <20121030040237.GA10472@google.com> <1352003971-22278-1-git-send-email-yinghai@kernel.org>
 <CAE9FiQUn=bcgOLFzBwsBT1-O1poRNy9qYTb0w9EAya3_inKqAw@mail.gmail.com>
 <CAErSpo5Z57asEXbfesOjXMEPj4WM3YMbzQH3s-v_NBrnPNmuVQ@mail.gmail.com>
 <CAErSpo4LS7ShCbeOm1s9ob1MjPfUSWn9J96UHRBP6van54swQA@mail.gmail.com>
 <CAE9FiQV5x1S1BNHrXq0wMRDx7PD5BoCh3fOnq2vS_AOAGL8Rrw@mail.gmail.com>
 <CAErSpo5vEb=63jGsqfau1G=f54oqq17pc3ZzcpzhL7hQrtYhng@mail.gmail.com> <CAE9FiQUxxjZmd3C33_ujSeL1EjcKHHSoGusQwfBD+Zd=cwCDZA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Jan 2013 11:39:28 -0700
Message-ID: <CAErSpo6qX3ih9DXLqxqJw141OAeTFu0YfSih6LyD0sd2gS-Vyg@mail.gmail.com>
Subject: Re: [PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for
 hot-add root bus
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 9, 2013 at 10:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Jan 9, 2013 at 9:35 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> I don't know, that could be separated patcheset after we conclude
>>> pci root bus hotplug support.
>>
>> The main reason I review patches before merging them is to identify
>> issues that we can fix before they affect everybody.  It makes my life
>> a lot easier if I don't have to keep track of pending unaddressed
>> review comments.  Is there an advantage to waiting and doing this work
>> later?
>>
>>>>> In general these look good.  My main concern is that they only touch
>>>>> x86, without touching the similar code in frv, microblaze, mn10300,
>>>>> and powerpc.
>
> the reason why we need to change those codes for x86, we want to make it support
> pci root bus hotplug. So it would be reasonable for us to align other
> platform to x86
> changes after pci root bus hotplug change is completely done.

OK, I opened https://bugzilla.kernel.org/show_bug.cgi?id=52531 as a
way to keep track of this consistency issue and merged
pci/yinghai-survey-resources to my -next branch.
