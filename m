Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1AJTYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:24:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41463 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1AJTYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:24:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xxxB30pDDJj81we2UxYnQJjNk7HkpVuACuMc6LdHl1Frt9cWxFPDTYMycNXqMXdtjg
         Ll9in1pMCR2rrABaZL1dp4JALLmUrdlniccQxBfNhOwnIRZ6G8aeZaW9cHX3g8I8lsjs
         AqsCD1paOZ0mIjiDkr9I5SnKa+RMShrcyRt+8=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101101931200.26685@pobox.suse.cz>
References: <1294425762-29730-1-git-send-email-benjamin.tissoires@enac.fr>
	<alpine.LNX.2.00.1101072355200.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101072359450.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101082224130.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101101931200.26685@pobox.suse.cz>
Date: Mon, 10 Jan 2011 20:24:12 +0100
X-Google-Sender-Auth: I8Tzb8KvxiG31FhlRjOMczLRy7E
Message-ID: <AANLkTi=BoBPZ-KxAn9NSECVv+7FB9DBTu5nchS3TN-rT@mail.gmail.com>
Subject: Re: [RFC v3 0/5] hid-multitouch: a first step towards multitouch unification
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 7:32 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 8 Jan 2011, Jiri Kosina wrote:
>
>> > > I have now applied the patchset as-is to the 'multitouch' branch in my
>> > > tree.
>> >
>> > Which means -- could you please send any followup patches on top of that
>> > branch (i.e. on top of the v3 patchset)? It would help my workflow and
>> > make the merging process smoother.
>>
>> 'multitouch' brach now builds, as Linus has taken Dmitry's pull request
>> and I have merged from Linus.
>>
>> So once you have fixed for the minor issues raised by Henrik and once you
>> have finished your testing, please send the additional fixes to me and I
>> will be merging the branch upstream.
>
> Hi Benjamin,
>
> we are now slowly aproaching the point in time in which I would like to
> prepare second round of HID tree merge with Linus.
>
> Have you finished your testing / fixing the minor issues raised by Henrik
> please?
>
> Thanks,
>

Hi Jiri,

I'm still waiting for one tester (the generaltouch one).

I hope he will be able to test it tomorrow (he told me he was busy until today).

I'm sure the driver works for two of the three devices (we have them
at the lab). The generaltouch is less important as there is a conflict
in the naming of the vendorID/deviceID:
GeneralTouch sells two different devices with the same deviceID, and
the older is handled by usbtouchscreen.
Stéphane explained to me today that people that want to use multitouch
features will have to do some manipulations to enable it.

I'll send the diff between v3-v4 tomorrow if you want or before if you
really need.

Cheers,
Benjamin
