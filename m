Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0JGUtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:49:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0JGUtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mEQhlJyzuvC5VrWj44rsz8HyZtvQog68W8bnlhkwkV8DBJudkfw3KA8Ufaa3rkP0wB
         76oTIhD3dzMMvJHqKO2jR9I/sOUBuVG2F6tTtloiQ+/1v+9nUQJh4ZcFdwX25RodH1rZ
         6uzYswzQfCwOGg0w4+s1l6I1cRELRyhEPCvUs=
MIME-Version: 1.0
In-Reply-To: <20101007133529.GA21782@srcf.ucam.org>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
	<20101007111510.GA19624@srcf.ucam.org>
	<AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
	<20101007133529.GA21782@srcf.ucam.org>
Date: Thu, 7 Oct 2010 15:49:05 -0500
X-Google-Sender-Auth: N9ujv0EKKwphzi6KZEcwx99Ic7w
Message-ID: <AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
From: Mario Limonciello <superm1@ubuntu.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew:

On Thu, Oct 7, 2010 at 08:35, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> On Thu, Oct 07, 2010 at 08:30:57AM -0500, Mario Limonciello wrote:
>
> >    In this specific scenario that Ken Yu submitted this patch for, the
> >    firmware will return the same return codes for the SMI's as a functional
> >    machine will.  Machines affected by this will fail to recover after rfkill
> >    is toggled twice.  The symptom will be that the soft block always appears
> >    set to the same setting with continued keypresses.
> >    During the prototype phase this option is quite useful to help debug the
> >    problem it addresses.
>
> Is the kernel able to unblock it under those circumstances?

Manually running rfkill unblock will unblock it in this broken
firmware scenario in question.

--
Mario Limonciello
superm1@gmail.com
