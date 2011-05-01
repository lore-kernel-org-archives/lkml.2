Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1EARLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 13:11:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33943 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1EARLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 13:11:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PbDA1Nk57ZcyMsn2T6OnBIdfpxd+KYqjij1sJssuQLG/0khBDkUPHXNP7Ssv8njGsP
         LqR82OpHxy85/SzE+xOSsCCYN+oa28BXmygLyrEtfWWzof0GTJj4L4DfFJSvxBHzvypV
         xHCSYHoRTeEb/YOrZnOv9gOZJclVUDxunXy9o=
MIME-Version: 1.0
In-Reply-To: <20110501164635.GA21833@elte.hu>
References: <20110430171459.685415696@openvz.org>
	<4DBC6DC1.30900@redhat.com>
	<20110501164635.GA21833@elte.hu>
Date: Sun, 1 May 2011 21:11:35 +0400
X-Google-Sender-Auth: yMzJkosGWUwICKHohqVk3rbPfbc
Message-ID: <BANLkTimpk3Ye=HvCohTbKT7Jzedo_V07Yg@mail.gmail.com>
Subject: Re: [patch 0/2] x2apic optimization, round 4
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 8:46 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Avi Kivity <avi@redhat.com> wrote:
>
>> On 04/30/2011 08:14 PM, Cyrill Gorcunov wrote:
>> >   Hi Ingo, here is an updated series of two patches for
>> >x2apic cluster mode ipi optimization. Please take a
>> >look.
>> >
>> >   The only concern which was unresolved is a messy bit
>> >in default_setup_apic_routing(), so we've added a FIXME
>> >there and clean it up as only time permits. Actually I
>> >have a plan to merge probe_32/64.c into single file (and
>> >even started working on this task) but not yes succeed.
>> >
>> >   Anyway I think patches should be in a good shape now and
>> >probably we could merge them to not lose?
>> >
>> >   Comments are welcome.
>>
>> Very nice!  This will also significantly speed up kvm guests using x2apic.
>
> Ok. It would be nice to know on what systems these patches were tested, i.e. i
> suppose x2apic-enabled ones?
>
> Thanks,
>
>        Ingo
>

Suresh has tested them on Westmere-Ex system, I personally don't have
such machine.
