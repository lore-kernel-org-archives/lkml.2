Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1I0OJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:09:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1I0OJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:09:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=SM90hbpy36VMGcx49OI8qg0tTenLrmm6ZPKe+hF4UEk4HQSF+z2eYYTbBx6c+52Mk
	afgHtyTr0Y/ZlkyYjDcmA==
MIME-Version: 1.0
In-Reply-To: <1317116380.4877.5.camel@mattotaupa>
References: <1316514056.3891.2.camel@mattotaupa> <CAErSpo4FACymQXs1fuDwP87_1U2XLTxC=wKLEK2Q0scxhw7R+Q@mail.gmail.com>
 <1317116380.4877.5.camel@mattotaupa>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Sep 2011 08:09:06 -0600
Message-ID: <CAErSpo6KopVRio-84uoUf1on+VQ6zuduypztXnUwcq_8iNtbjw@mail.gmail.com>
Subject: Re: [PATCH v2] x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: x86@kernel.org, linux-pci@vger.kernel.org, stable@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 3:39 AM, Paul Menzel
<paulepanter@users.sourceforge.net> wrote:
> Am Dienstag, den 20.09.2011, 10:39 -0600 schrieb Bjorn Helgaas:
>> On Tue, Sep 20, 2011 at 4:20 AM, Paul Menzel wrote:
>> > ...
>> >
>> > Using coreboot [1] with this board the problem does not exist but this quirk also does not affect it either. To be safe though the check is tightened to only take effect when the BIOS from American Megatrends is used.
>> >
>> >        15:13 < ruik> but coreboot does not need that
>> >        15:13 < ruik> because i have there only one root bus
>> >        15:13 < ruik> the audio is behind a bridge
>>
>> I'd like to know more about this coreboot situation.  Would it be
>> possible to get a dmesg log from the system with coreboot?  I'd like
>> to see how coreboot configures this device differently.
>
> I had attached that to the Bugzilla report #30552 [2], but this is down
> at the moment. I saw that you got the output from someone on #coreboot
> though.
>
>> > CC: stable@kernel.org (≥ 2.6.34)
>> > CC: Bjorn Helgaas <bhelgaas@google.com>
>> > CC: Thomas Gleixner <tglx@linutronix.de>
>> > CC: Ingo Molnar <mingo@redhat.com>
>> > CC: H. Peter Anvin <hpa@zytor.com>
>> > CC: x86@kernel.org
>> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
>> > Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
>>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> This is fine with me.  I don't think it's the final solution, but I
>> think it's worth doing for now.
>
> Thank you. I could not see this in Linus’ tree [3] yet. Jesse, could you
> pick that up as you have done for the other commit? (Where is your
> (temporary) tree located?)

Jesse's on vacation right now.  I'm in the middle of setting up a
temporary tree for the interim.

Bjorn
