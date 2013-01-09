Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3AIDNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:13:35 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53097 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3AIDNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:13:34 -0500
Message-ID: <50ECE08E.4020003@gmail.com>
Date: Wed, 09 Jan 2013 11:14:22 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        "lin >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [Consult] our latest kernel and latest Android  under arm Samsung
 S5PV210 with yaffs2 file system
References: <50EBF402.5070007@gmail.com> <20130108145346.GC27837@thunk.org>
In-Reply-To: <20130108145346.GC27837@thunk.org>
Content-Type: multipart/mixed;
 boundary="------------050609030700010001080700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050609030700010001080700
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

于 2013年01月08日 22:53, Theodore Ts'o 写道:

  firstly, thank you for your reply in details.

  :-)

> yaffs2 is not a _standard_ file system for Android.  There may be some
> phones which use it, but the much more common is either FAT (for the
> older phones) or ext4.  The Google AOSP releases for pretty much all
> modern Nexus phones (Galaxy Nexus and newer if I recall correctly,
> certainly for GN, N4, N7, etc.) all use ext4.
> 
  for development, yaffs2 may be not a _standard_ file system for Android.
  but for marketing, it is realy used as a common file system.
  as far as I know:
    some of HTC phone use it.
    some embedded developement board use it.
    it is well known in embedded area (can find many documents about it)


> 
> So if your existing Android device is using yaffs2, you'll need to
> integrate yaffs2, since yaff2 is not in the upstream kernel.  As far
> as hardware support, it will depend on the specifics of your
> development board, ...
>

  thank you for your suggestions.
  I will integrate yaffs2 to my current using kernel.


> ..., Others hopefully on this list will be able to answer it.
> 
> 
  welcome any members to reply, thanks.


  and additional consult:
    is it suitable to integrate yaffs2 into upstream kernel ?

  :-)


  thanks.

-- 
Chen Gang

Flying Transformer

--------------050609030700010001080700
Content-Type: text/x-vcard; charset=utf-8;
 name="chen_gang_flying_transformer.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="chen_gang_flying_transformer.vcf"

YmVnaW46dmNhcmQNCmZuOkNoZW4gR2FuZw0Kbjo7Q2hlbiBHYW5nDQp2ZXJzaW9uOjIuMQ0K
ZW5kOnZjYXJkDQoNCg==
--------------050609030700010001080700--
