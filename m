Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0GXIGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:06:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53656 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0GXIGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OgQBC+A7cpIT9iZeKmXSDIpSkqCt/wGao8gLIK7ejwV26+svG1RYdK+UvW/Hbw4mZ5
         RljpSioE/MWS/OskyYhXxyMdqj23ofbfSTqLeg8/7NfOHVRDJpqjwiNwMiQksVYqp6zM
         SF/ql7zdEcPHK55lDD4bU0X+QTn2kObGV2kWg=
Message-ID: <4C4A9EF8.6030409@gmail.com>
Date: Sat, 24 Jul 2010 10:06:16 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Michal Marek <mmarek@suse.cz>, Greg KH <greg@kroah.com>
Subject: Re: Linux 2.6.35-rc6
References: <AANLkTinJe-oHpgQqnTPQyKUtmKhg2oUJmylkBPALuzGh@mail.gmail.com> <20100723112142.f698394e.sfr@canb.auug.org.au>
In-Reply-To: <20100723112142.f698394e.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 03:21 AM, Stephen Rothwell wrote:
> On Thu, 22 Jul 2010 12:26:13 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>  I actually hope/think that this is going to be the last -rc. Things
>> have been pretty quiet, and while this -rc has more commits than -rc5
>> had, it's not by a large amount, nor does it look scary to me. So
>> there doesn't seem to be any point in dragging out the release any
>> more, unless we find something new that calls for it.
> 
> I have no idea how important this stuff is, but I still have the
> following in linux-next that are (in theory) destined for v2.6.35:

Hi, and probably this one as well (introduced in rc1):
http://lkml.org/lkml/2010/7/9/287

Tim Gardner
  i915: Use the correct mask to detect i830 aperture size.

-- 
js
