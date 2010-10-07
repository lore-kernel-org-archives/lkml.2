Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0JGVp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:45:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab0JGVp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:45:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Oe9X/CTCjb+SGTIN0LKBWNrJuBWcIsqHky6DHaSXvVNap2WLc7Kdzurt9szn3Px7b3
         MbKJ0kTewmfcqfLzOJjyexo79Ls7qxCuY8cMZ+me0c9w158fjN4OO4RTVpdISjPco5S/
         TBcSz/JJ5CNGVQMJCrXX5ToZZVdoFJSYqgYsI=
MIME-Version: 1.0
In-Reply-To: <20101007214212.GA2010@srcf.ucam.org>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
	<20101007111510.GA19624@srcf.ucam.org>
	<AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
	<20101007133529.GA21782@srcf.ucam.org>
	<AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
	<20101007205049.GB32726@srcf.ucam.org>
	<AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
	<20101007213027.GA18628@core.coreip.homeip.net>
	<20101007213754.GA1896@srcf.ucam.org>
	<AANLkTinL9UckjiQGmMJ_NENPp9XxFHRdvTje_V46LPQ+@mail.gmail.com>
	<20101007214212.GA2010@srcf.ucam.org>
Date: Thu, 7 Oct 2010 16:45:22 -0500
X-Google-Sender-Auth: YHYphPNoeeQ5_S0jvwb2PF-p4V4
Message-ID: <AANLkTimh649Lhj-sBYzViq_G-2Bva0U-TPCMGfSdK=QE@mail.gmail.com>
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
From: Mario Limonciello <superm1@ubuntu.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew:

On Thu, Oct 7, 2010 at 16:42, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Oct 07, 2010 at 04:41:12PM -0500, Mario Limonciello wrote:
>
>> All Dell laptops are /supposed/ to adhere to the specification in
>> question.  Unfortunately, not all machines are tested with Linux
>> during their development and on the OS they ship with that
>> functionality isn't always used in that specific way for rfkill.
>
> I don't understand this. You know which code is broken - surely you're
> able to determine which products shipped with BIOSes derived from the
> broken code?
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Not all product's BIOS are developed in-house.  The ones that are, yes
it quite possible to identify.  Matter of fact, this issue tends to
not exist on the in-house developed BIOS codebase.


-- 
Mario Limonciello
superm1@gmail.com
