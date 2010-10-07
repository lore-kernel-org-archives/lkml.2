Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0JGSFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:05:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0JGSFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bn9PfAMpLTAVvCJw0jkSGCH2dfy/LTpgnnTmeJQirWLrvwkW/xPRFWP4gsdFrO2rtw
         Ukkwc/h1C/D77eAxRSpg==
MIME-Version: 1.0
In-Reply-To: <20101007174626.GA31541@suse.de>
References: <1286406919-6236-1-git-send-email-snanda@chromium.org>
 <20101007021959.GA7300@suse.de> <AANLkTimE2h46iZkj_amvgUg5UwN9xjuwqdW5TB+XccYy@mail.gmail.com>
 <20101007174626.GA31541@suse.de>
From: Sameer Nanda <snanda@chromium.org>
Date: Thu, 7 Oct 2010 11:05:21 -0700
X-Google-Sender-Auth: mqDfOovffGWxE4jOqT-rTgyNcM8
Message-ID: <AANLkTik=imw5XRpXSkboyB6txXio6Y65bLV+EdfvRXg3@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Read TSC upon resume
To: Greg KH <gregkh@suse.de>
Cc: lenb@kernel.org, stefan.bader@canonical.com, brad.figg@canonical.com,
        apw@canonical.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 10:46 AM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Oct 07, 2010 at 10:43:34AM -0700, Sameer Nanda wrote:
>> On Wed, Oct 6, 2010 at 7:19 PM, Greg KH <gregkh@suse.de> wrote:
>> > And are you always going to be printing this out?  Why do we want to
>> > know this every time?
>> >
>>
>> Yes, every time.  This helps track variance in BIOS resume times within a
>> single boot.
>
> Is that really something that users can do something about?

Aside from complaining to the BIOS vendors, no :)

> I can
> understand when you are trying to work with a BIOS company, but
> otherwise, this seems quite pointless.
>
> thanks,
>
> greg k-h
>



-- 
Sameer
