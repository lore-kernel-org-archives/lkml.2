Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182Ab0FQWXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 18:23:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57965 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560Ab0FQWXi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 18:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CODskh2OtqHHWSOqlKtImMYJNAwWd1yUEMLMrJInm5uuWuzALCd9a/XRpq1pk+JAyj
         pC6oiT8TQzu2/pQaZk829BavubDa1SjprRP2lbCdamA/VywllvAv7IPahJ4b73V2f94R
         zkSuA95AGvq+r7SUjMugJjuo2CGk9S6evkaxA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006171500260.4214@localhost.localdomain>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
	<0F1C0B07-60D6-405B-890B-F9C320820CA5@gmail.com>
	<alpine.LFD.2.00.1006171500260.4214@localhost.localdomain>
Date: Thu, 17 Jun 2010 17:23:35 -0500
Message-ID: <AANLkTimWfE0WXr558sOnjZFptxpP4k6IvMWriR3seIKu@mail.gmail.com>
Subject: Re: [linux-pm] RFC: /sys/power/policy_preference
From: Victor Lowther <victor.lowther@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 2:02 PM, Len Brown <lenb@kernel.org> wrote:
>
>> On Jun 16, 2010, at 4:05 PM, Len Brown <lenb@kernel.org> wrote:
>>
>> > Create /sys/power/policy_preference, giving user-space
>> > the ability to express its preference for kernel based
>> > power vs. performance decisions in a single place.
>> >
>> > This gives kernel sub-systems and drivers a central place
>> > to discover this system-wide policy preference.
>> > It also allows user-space to not have to be updated
>> > every time a sub-system or driver adds a new power/perf knob.
>>
>> I would prefer documenting all the current knobs and adding them to pm-utils
>> so that pm-powersave knows about and can manage them. Once that is done,
>> creating arbitrary powersave levels should be fairly simple.
>
>
> The idea here is to not require user-space to need updating
> whenever a future knob is invented.  We can do a great job
> at documenting the past, but a poor job of documenting the future:-)

Well, I would suggest that the habit of not documenting what is
happening with power management in the kernel needs to change, then.

Having the documentation and example code for how to tweak the various
power management settings from userspace is inherently more flexible
than trying to expose a single knob from the kernel to userspace for
power management, with little loss of flexibility.
> cheers,
> Len Brown, Intel Open Source Technolgy Center
>
