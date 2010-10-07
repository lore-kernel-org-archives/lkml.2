Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0JGUxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:53:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab0JGUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:53:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jaJ1YQcvuHScS2D0JdIYuLvFQcd+kg39rN76hrS4/WDPHZr4WAa3nmcsGL5XTyr3x8
         OcgScqBnpqoWaekrHkV8jJKUx3+nS5eOyHxWxyZwSeWTqP5qodDS2HaORpncg0AQ+5y4
         jQ6JwuZL6R9EADkS58eXvLWN854qZ/YpZPlzo=
MIME-Version: 1.0
In-Reply-To: <20101007205049.GB32726@srcf.ucam.org>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
	<20101007111510.GA19624@srcf.ucam.org>
	<AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
	<20101007133529.GA21782@srcf.ucam.org>
	<AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
	<20101007205049.GB32726@srcf.ucam.org>
Date: Thu, 7 Oct 2010 15:53:37 -0500
X-Google-Sender-Auth: mgfG_LxlwFvsAjkglYo25vgY95Y
Message-ID: <AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
From: Mario Limonciello <superm1@ubuntu.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew:

On Thu, Oct 7, 2010 at 15:50, Matthew Garrett <mjg@redhat.com> wrote:
> On Thu, Oct 07, 2010 at 03:49:05PM -0500, Mario Limonciello wrote:
>> Hi Matthew:
>> > Is the kernel able to unblock it under those circumstances?
>>
>> Manually running rfkill unblock will unblock it in this broken
>> firmware scenario in question.
>
> So the issue is in the firmware's response to the keystroke? Ok. I'd
> rather have a DMI list of the broken machines than a module parameter.

Yes the issue is the firmware's response to the keystroke.  The
intention here is to individual submit machines in future patches as
they're discovered.  The parameter's primary purpose is to assist in
building the list.  If someone reports a bug with these symptoms, they
can add the parameter to their kernel command line, and report if it
helps them.  If it helps, their machine can be added to the DMI table.

-- 
Mario Limonciello
superm1@gmail.com
