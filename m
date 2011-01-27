Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1A0TX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:23:29 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52760 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1A0TX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:23:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AxVEhaTHUB+wTAOATKw0XU9eaJVvYKR9AaxOnM9waG+1di4oJVAIDvun1/ZsyHxAPN
         adEMXU0LblETytOrfdYA==
MIME-Version: 1.0
In-Reply-To: <20110127104343.5931161e@lxorguk.ukuu.org.uk>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com> <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com> <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
 <20110127104343.5931161e@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Date: Thu, 27 Jan 2011 11:22:55 -0800
Message-ID: <AANLkTikGJJsnAwiyhrS6m8TJQfR8UHCzZG+t=2GHFRiW@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Content-Type: multipart/mixed; boundary=000e0cd32d8c9987b9049ad8e164
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd32d8c9987b9049ad8e164
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 27, 2011 at 2:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I understand that type widths change in a compat setting. =A0So what?
>> Code in each environment is written to it's own namespace anyhow.
>
> So you ned up with a pile of extra crap in the kernel to handle 32bit
> userspace on 64bit and the like. If instead the structs are carefully
> laid out this doesn't occur.
>
>> Here's what *I* think *you* think about __u32 vs u32 vs uint32_t.
>> Correct me if I'm totally off-base here:
>
> And the __aligned_ ones for things like u64 in ioctls and structs...
>
> It's also a style and consistency thing, its trivialto use the same style
> as the rest of the kernel, it's trivial to tweak and it helps keep
> coherency of style, even if you are sitting at the keyboard mumbling
> "bunch of morons if you ask me" while doing it ;)

I'm always mumbling and cursing at my desk :p

I've already changed the series to not use C99 types.  I understand
the value in style consistency :)

I'm still trying to understand if there is any actual technical merit
to avoid standard types though, of which there doesn't seem to be any.

Anyhow, I've attached a patch that fixes the style documentation.

--000e0cd32d8c9987b9049ad8e164
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjg1vq1u0

Q29kaW5nU3R5bGU6IEZpeCBkb2N1bWVudGF0aW9uIG9uIHVzZSBvZiBDOTkgdHlwZXMuCgpSZWFs
aXR5IGhhcyBpdCB0aGF0IG5ldyBjb2RlIGlzIGRpc2NvdXJhZ2VkIGZyb20gdXNpbmcgQzk5IGV4
YWN0IHdpZHRoCnR5cGVzLiAgRml4IHRoZSBkb2N1bWVudGF0aW9uLgoKU2lnbmVkLW9mZi1ieTog
TWlrZSBXYXljaGlzb24gPG1pa2V3QGdvb2dsZS5jb20+CmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0
aW9uL0NvZGluZ1N0eWxlIGIvRG9jdW1lbnRhdGlvbi9Db2RpbmdTdHlsZQppbmRleCA4YmIzNzIz
Li44ZGQyZTc3IDEwMDY0NAotLS0gYS9Eb2N1bWVudGF0aW9uL0NvZGluZ1N0eWxlCisrKyBiL0Rv
Y3VtZW50YXRpb24vQ29kaW5nU3R5bGUKQEAgLTMyMyw4ICszMjMsNyBAQCB1c2VmdWwgb25seSBm
b3I6CiAKICAgICAgVGhlcmVmb3JlLCB0aGUgTGludXgtc3BlY2lmaWMgJ3U4L3UxNi91MzIvdTY0
JyB0eXBlcyBhbmQgdGhlaXIKICAgICAgc2lnbmVkIGVxdWl2YWxlbnRzIHdoaWNoIGFyZSBpZGVu
dGljYWwgdG8gc3RhbmRhcmQgdHlwZXMgYXJlCi0gICAgIHBlcm1pdHRlZCAtLSBhbHRob3VnaCB0
aGV5IGFyZSBub3QgbWFuZGF0b3J5IGluIG5ldyBjb2RlIG9mIHlvdXIKLSAgICAgb3duLgorICAg
ICBwcmVmZXJyZWQuCiAKICAgICAgV2hlbiBlZGl0aW5nIGV4aXN0aW5nIGNvZGUgd2hpY2ggYWxy
ZWFkeSB1c2VzIG9uZSBvciB0aGUgb3RoZXIgc2V0CiAgICAgIG9mIHR5cGVzLCB5b3Ugc2hvdWxk
IGNvbmZvcm0gdG8gdGhlIGV4aXN0aW5nIGNob2ljZXMgaW4gdGhhdCBjb2RlLgo=
--000e0cd32d8c9987b9049ad8e164--
