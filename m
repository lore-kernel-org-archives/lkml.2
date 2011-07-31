Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1GaELQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 00:11:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54290 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1GaELJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 00:11:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAGTjWtBw7JJHQFnxjDJEs58LyO2wX98aNWKtCmrQ3fYzebX2Xw@mail.gmail.com>
References: <CAC-0EqgJtddENZO_=kmjSy8-bocLf+ansDbpGwbkb+a3YLakLQ@mail.gmail.com>
	<CAGTjWtBw7JJHQFnxjDJEs58LyO2wX98aNWKtCmrQ3fYzebX2Xw@mail.gmail.com>
Date: Sat, 30 Jul 2011 22:11:09 -0600
Message-ID: <CAC-0EqjA_9QKZOGbmYL0A2-xKWxycU1bY59dJERB6_rGRpQR2g@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] firmware: Add DMI entry types to the headers
From: David Hubbard <david.c.hubbard@gmail.com>
To: Mike Waychison <mikew@google.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Greg KH <greg@kroah.com>
Content-Type: multipart/mixed; boundary=0016363b935a4d089604a955b40f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363b935a4d089604a955b40f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mike,

>>> In preparation for the upcoming commits, introduce the DMI entry types =
to
>>> the headers. =A0These type names are based on those specified in the DM=
TF
>>> SMBIOS specification version 2.7.1.
>>>
>>> Signed-off-by: Mike Waychison <mikew@google.com>
>>> ---
>>> =A0include/linux/dmi.h | =A0 47 +++++++++++++++++++++++++++++++++++++++=
++++++++
>>> =A01 files changed, 47 insertions(+), 0 deletions(-)
>>
>> I noticed a missing entry w.r.t. dmi_smbios_structure_type() in dmidecod=
e.c:
>>
>> --- include/linux/dmi.h 2011-07-24 17:14:34.000000000 -0600
>> +++ include/linux/dmi.h 2011-07-24 17:14:49.000000000 -0600
>> @@ -57,6 +57,7 @@
>> =A0 =A0 =A0 =A0DMI_ENTRY_OOB_REMOTE_ACCESS,
>> =A0 =A0 =A0 =A0DMI_ENTRY_BIS_ENTRY,
>> =A0 =A0 =A0 =A0DMI_ENTRY_SYSTEM_BOOT,
>> + =A0 =A0 =A0 DMI_ENTRY_64_MEM_ERROR,
>> =A0 =A0 =A0 =A0DMI_ENTRY_MGMT_DEV,
>> =A0 =A0 =A0 =A0DMI_ENTRY_MGMT_DEV_COMPONENT,
>> =A0 =A0 =A0 =A0DMI_ENTRY_MGMT_DEV_THRES,
>
> Good catch. =A0Looks like I screwed this up when transcribing the types
> from the docs. =A0 Good thing nobody depends on these later enums yet ;)
>
> Can you post a patch in the canonical format specified in
> Documentation/SubmittingPatches ?
>

Gmail makes it unnecessarily complicated, converting tabs to spaces.
Here's my attempt. If the in-body patch fails, below, I have attached
it as well as a backup.


Add a missing DMI type (DMI_ENTRY_64_MEM_ERROR).

Patch is against 2.6.39. I can resubmit against the latest git tree if
the patch doesn't apply cleanly.

Signed-off-by: David Hubbard <david.c.hubbard@gmail.com>

--- include/linux/dmi.h.2.6.39	2011-07-30 22:06:05.000000000 -0600
+++ include/linux/dmi.h	2011-07-30 22:06:39.000000000 -0600
@@ -57,6 +57,7 @@ enum dmi_entry_type {
 	DMI_ENTRY_OOB_REMOTE_ACCESS,
 	DMI_ENTRY_BIS_ENTRY,
 	DMI_ENTRY_SYSTEM_BOOT,
+	DMI_ENTRY_64_MEM_ERROR,
 	DMI_ENTRY_MGMT_DEV,
 	DMI_ENTRY_MGMT_DEV_COMPONENT,
 	DMI_ENTRY_MGMT_DEV_THRES,

--0016363b935a4d089604a955b40f
Content-Type: text/plain; charset=US-ASCII; 
	name="firmware_add_missing_entry_type.patch.txt"
Content-Disposition: attachment; 
	filename="firmware_add_missing_entry_type.patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqrhsycr0

LS0tIGluY2x1ZGUvbGludXgvZG1pLmguMi42LjM5CTIwMTEtMDctMzAgMjI6MDY6MDUuMDAwMDAw
MDAwIC0wNjAwCisrKyBpbmNsdWRlL2xpbnV4L2RtaS5oCTIwMTEtMDctMzAgMjI6MDY6MzkuMDAw
MDAwMDAwIC0wNjAwCkBAIC01Nyw2ICs1Nyw3IEBAIGVudW0gZG1pX2VudHJ5X3R5cGUgewogCURN
SV9FTlRSWV9PT0JfUkVNT1RFX0FDQ0VTUywKIAlETUlfRU5UUllfQklTX0VOVFJZLAogCURNSV9F
TlRSWV9TWVNURU1fQk9PVCwKKwlETUlfRU5UUllfNjRfTUVNX0VSUk9SLAogCURNSV9FTlRSWV9N
R01UX0RFViwKIAlETUlfRU5UUllfTUdNVF9ERVZfQ09NUE9ORU5ULAogCURNSV9FTlRSWV9NR01U
X0RFVl9USFJFUywK
--0016363b935a4d089604a955b40f--
