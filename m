Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0JMRnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 13:43:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45829 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0JMRm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 13:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=kVSYwDxgrOiIKVP56dIsDdNUvzKKjVybPEcHG3TRGsParLZPjA2oMrygp79xpOmYRm
         oFv0CE5Dh48PXsNTCuwp3DBxatji9qf3E2ODsULG79CKdMJw7Pzm2mAPblgsbb8zvmj8
         duTpSfRfzd6a3uhs/FsncYajfpihgJZ3MCutQ=
MIME-Version: 1.0
In-Reply-To: <1286964370.3316.6.camel@aeonflux>
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com>
 <20101008181508.GM10149@tux> <20101012211726.GE2678@broadcom.com> <1286964370.3316.6.camel@aeonflux>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 13 Oct 2010 10:42:38 -0700
X-Google-Sender-Auth: DlwfbQSwfNAVyJDNE8jasNx-BBc
Message-ID: <AANLkTimAeoS2Vi7GhKSTrghqaOQ=XKSzjcou15dn+YDR@mail.gmail.com>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or replace
 ath3k-1.fw ?
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Henry Ptasinski <henryp@broadcom.com>,
        Suraj Sumangala <Suraj.Sumangala@atheros.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 3:06 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Henry,
>
>> > > Marcel had answered me before. It makes sense to have same file name.
>> > > Other ways we end up changing the driver whenever there is a firmware
>> > > change.
>> >
>> > > > I last tried to document a thread we had over this here:
>> > > >
>> > > > http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
>> > > >
>> >
>> > Thanks, I've updated that link above to document bug fixing does not require
>> > a filename change.
>>
>> I don't really understand why you would not want to change the code revision
>> part of the filename.
>>
>> I totally agree that you don't want to change the driver every time the
>> firmware gets a bug fix, but wasn't that the whole point of splitting the name
>> into API and code revisions portions, and symlinking the file to one that just
>> has the API version?
>>
>> What's the issue with using the process as originally documented?
>
> as I stated before, for Bluetooth this makes no sense. You don't need
> API version numbers since the API is a STANDARD. It is called HCI. So
> please don't use API version numbers in the firmware files.
>
> I will reject firmware file versions for upstream drivers.

Does the HCI standard ever get improved upon? If so, how do devices
never get firmware updates that would allow them to use some newer HCI
APIs?

I've updated the documentation above for 802.11 and Bluetooth with the
above, please feel free to further extend it as you see fit.

  Luis
