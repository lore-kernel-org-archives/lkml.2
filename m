Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1AGJs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:48:28 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43936 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1AGJsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VBNoQvOGd8XYbXTxNojeqzZnJ73atr1C6UofoAj9zCNbqQTcpEpp+j31v5Eby6BqkC
         A9zcOOh1rA+4bFPInTeG26S49UyuqKsOeOJRVhyVS+c+t14DbOm+cHo1mC/dgsIRztdF
         d39Pu0PEYB1oer0MJZr/nvr2Xs6/Eh433OTnE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101071040470.26685@pobox.suse.cz>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<20110105174927.GB2146@polaris.bitmath.org>
	<AANLkTikCqufvOgYqqBZLjfmtSdsgyQV4L2HyvEP07+vf@mail.gmail.com>
	<alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz>
	<20110107011444.GA7262@core.coreip.homeip.net>
	<alpine.LNX.2.00.1101071040470.26685@pobox.suse.cz>
Date: Fri, 7 Jan 2011 10:48:24 +0100
X-Google-Sender-Auth: lUm9wfSCIgb4YyqqSGpiSBaaFZc
Message-ID: <AANLkTik7--frFi=9avRMeBHAdrOm+YvvGG-FURKy0JX4@mail.gmail.com>
Subject: Re: [RFC v2 0/10] hid-multitouch: a first step towards multitouch unification
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 10:41 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 6 Jan 2011, Dmitry Torokhov wrote:
>
>> > In case the patchset doesn't impose danger of regressions for already
>> > existing devices, we could merge this new 'unified' driver only for newly
>> > supported devices, and finish the unification in 2.6.39.
>>
>> Yep, let's merge the dirver and all new devices in this round and then
>> get ready to convert already supported devices in next window.
>
> Fully agreed, as I have written elsewhere already.
>
> Benjamin, when do you expect to have the patches for .38 ready? The merge
> window is already open, so that I could schedule the merges properly.

I'm doing my best to have the v3 today with only the 3 new devices.
After, we may have to find a consensus for the not ideal
implementation.

Cheers,
Benjamin


>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
