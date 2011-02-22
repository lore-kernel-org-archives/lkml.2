Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1BVHet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:34:49 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50282 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1BVHer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tXpM8G4uDy2vWPTQpbXeKRv9R8AdHkq3Hl1UTxBduCfi+WKNFdiP/hDUCzvCHS4Ocq
         Ro0thSRCj78loHBV1R3PYvTrPuEbVdSR4tTLk3nwoYvGR+wsViSFrhoC/z7qrchchU31
         hp1IHDIesnqnCjMtd7Uq1kPRJukKEo5M19wFM=
MIME-Version: 1.0
In-Reply-To: <4D635EEF.2060102@parallels.com>
References: <4D6095E3.2040103@parallels.com>
	<20110221185205.GA23284@mako-laptop>
	<4D62C43F.5040302@parallels.com>
	<20110221120303.48106f6c.rdunlap@xenotime.net>
	<4D62CC6B.9070408@parallels.com>
	<20110221125555.4a47424d.rdunlap@xenotime.net>
	<AANLkTi=Uhvz9VfQeXNMH+_-OLp--VdZswAUeU6dz4PQd@mail.gmail.com>
	<4D635EEF.2060102@parallels.com>
Date: Tue, 22 Feb 2011 15:34:46 +0800
Message-ID: <AANLkTimLAMZoysa8-wE2M2vMPChTzqfDc4U3zz8j9+MX@mail.gmail.com>
Subject: Re: [PATCH] Remove obsolete Documentation/00-INDEX entries
From: Jovi Zhang <bookjovi@gmail.com>
To: Rob Landley <rlandley@parallels.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Mariusz Kozlowski <mk@lab.zgora.pl>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 2:59 PM, Rob Landley <rlandley@parallels.com> wrote:
> On 02/21/2011 11:43 PM, Jovi Zhang wrote:
>> There also have many doc located in Documentation directory, but not
>> in 00-INDEX file, like
>> apparmor.txt
>> bad_memory.txt
>> braille-console.txt
>> bt8xxgpio.txt
>> circular-buffers.txt
>> coccinelle.txt
>> credentials.txt
>> debugging-via-ohci1394.txt
>> devicetree/
>> dmaengine.txt
>> dynamic-debug-howto.txt
>> email-clients.txt
>> flexible-arrays.txt
>> futex-requeue-pi.txt
>> gcov.txt
>> ...
>>
>> Also there have some entry not list as alphabetical order.
>
> My script lists those as well: it finds a little over 1100 of them,
> which is why I didn't post the list.  (Here it is gzipped and attached.)
>  But that's also listing files for directories that have no 00-INDEX, so
> I should probably filter that better...
>
> Is alphabetical order a requirement?
>
> Rob
>

Hmm, not sure..., The header of 00-INDEX is like this:
>>>>
This is a brief list of all the files in ./linux/Documentation and what
they contain. If you add a documentation file, please list it here in
alphabetical order as well, or risk being hunted down like a rabid dog.
Please try and keep the descriptions small enough to fit on one line.
                                                        Thanks -- Paul G.
<<<
