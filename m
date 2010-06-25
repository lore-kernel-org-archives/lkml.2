Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0FYA3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 20:29:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37409 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0FYA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 20:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d8Nd7l2wbL5fCSGFQS2/JZNJHrUT/IDtDok67z9g2/RWzpJtLYdEirSVEiHUYyTRAA
         B/TnXFiv2F1VnjSNSYPLEH8y0ZPL61Dk2qrZe1n4KqjWxlDre77GcYoaa1Op+lf99J9G
         ukj2Pt3as4ZQjim6x/L6RuNHxK/tRJv5fOgkg=
Message-ID: <4C23F86C.5090502@gmail.com>
Date: Thu, 24 Jun 2010 18:29:32 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Ubuntu patch enabling speedstep for sonoma processors
References: <4C237EAE.3000908@pardus.org.tr>
In-Reply-To: <4C237EAE.3000908@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 09:50 AM, Ozan Çağlayan wrote:
> Hi,
>
> The following patch enables speedstep for sonoma processors:
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-maverick.git;a=blobdiff;f=arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c;h=ee4e9f8050752923f9671f61ffbea662bc9ad12a;hp=9b1ff37de46ae6a729f48d2d94ad30548806884d;hb=23120eb5ae5a12924565e8af3d946a015e1caaf9;hpb=215cc71ef0b26b9434404f387681d9bd173d2434
>
> The patch never got accepted by upstream after some discussions:
>
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-06/msg01078.html
>
> """
> This patch has been floating around for years.
> So long, I've forgotten the original reason it wasn't accepted.
> It had something to do with it working for some users, but not others,
> and we can't detect the 'not working' case.
>
> speedstep-centrino is also deprecated in favour of acpi-cpufreq for some time.
> If acpi isn't working on these machines, we should find out why.
>
> Dave Jones
> """
>
> """
> My recollection is that we had no way to work out which voltage table
> was appropriate for a given CPU, so there was a risk of us either over-
> or under-volting the chip. Doing it via ACPI is safe.
>
> Matthew Garrett
> """
>
> I have bug report from a user which complains that frequency scaling is not available
> on its computer. This patch fixes the issue but seen the discussions there should be a
> better and more correct way to fix the issue.
>
> What should I do in order to debug and try to fix it?
>
> And also seen that Ubuntu carries this patch for a relatively long time, did you see
> any negative effect like the aforementioned risk of over/under-volting the chip?

The acpidump from that system would be a good start, to figure out why 
acpi-cpufreq isn't working..
