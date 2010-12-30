Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0L3ALo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:11:44 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57264 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab0L3ALn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZMHZoKK0rNlRruUZfO+rHPFEIECmLqZbhAr6jATEpqb2dsDvEK5Y5ObN5VkKWB/Gxa
         3beiDH4WxzX8o0nIcrrmGPfKFeeUF+EZrdcgaEgfRoJMPGgTLFmhx93RlKxlk/W8M+KZ
         92l6NdKKhgWdMBfRCvSSV2Ky6bCmuQ9FLhHtY=
MIME-Version: 1.0
In-Reply-To: <4D1BC94C.5040100@zytor.com>
References: <4D0C072D.1040201@kernel.org>
	<4D19320B.7030007@kernel.org>
	<4D1933D1.9020609@kernel.org>
	<4D1BC856.4010202@kernel.org>
	<4D1BC94C.5040100@zytor.com>
Date: Wed, 29 Dec 2010 16:11:40 -0800
X-Google-Sender-Auth: jRJaEbXDTWKQklcDbRjPMJjZI2M
Message-ID: <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com>
Subject: Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to local node memory
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 3:50 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/29/2010 03:46 PM, Yinghai Lu wrote:
>>
>> -v2: update it to recent numa-emulation change
>>
>
> Lovely, yet another interbranch conflict.  This makes me very concerned.
>
> What is the delta between these?
>

your new x86/numa have

       setup_physnodes(addr, max_addr, acpi, amd);
       fake_physnodes(acpi, amd, num_nodes);

instead of

        acpi_fake_nodes(nodes, num_nodes);

in  numa_emulation()

Thanks

Yinghai
