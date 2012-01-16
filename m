Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2APLfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:35:42 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46762 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219Ab2APLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:35:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
References: <201111160019.51303.rjw@sisk.pl>
	<201201091700.09318.roucaries.bastien@gmail.com>
	<20120116004110.GA21240@srcf.ucam.org>
	<CAE2SPAZH9vQ=7mTxaCGY6DHdf5Yvv-0SWCwUobUY3tTD5caLow@mail.gmail.com>
Date: Mon, 16 Jan 2012 12:35:40 +0100
Message-ID: <CAE2SPAax24rQZTBRih9X9bOguQSSNW7snOuNb12jy2gwO_tKfQ@mail.gmail.com>
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to
 require PCI reboot
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: multipart/mixed; boundary=14dae9d2f79e32c50704b6a39d57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9d2f79e32c50704b6a39d57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Add FACP

2012/1/16 Bastien ROUCARIES <roucaries.bastien@gmail.com>:
> On Mon, Jan 16, 2012 at 1:41 AM, Matthew Garrett <mjg59@srcf.ucam.org> wr=
ote:
>> On Mon, Jan 09, 2012 at 05:00:08PM +0100, bastien ROUCARIES wrote:
>>> Le Wednesday 16 November 2011 00:19:51, Rafael J. Wysocki a =C3=A9crit =
:
>>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>>> >
>>> > Dell OptiPlex 990 is known to require PCI reboot, so add it to the re=
boot
>>> > blacklist in pci_reboot_dmi_table[].
>>>
>>>
>>> Sorry to hi jack this thread but it seems that dell made the same crap =
with my precision T1600. See
>>> http://www.centos.org/modules/newbb/print.php?form=3D1&topic_id=3D32948=
&forum=3D55&order=3DASC&start=3D0
>>> or
>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D698239
>>
>> Does it work if you disable VT-d in the firmware? If so, then adding it
>> to the reboot method blacklist is the wrong fix - we need to figure out
>> why VT-d interferes with Dell's reboot code.
>
> Yes it work
>
> I suppose you need DSDT ? Join here
>
>>
>> --
>> Matthew Garrett | mjg59@srcf.ucam.org

--14dae9d2f79e32c50704b6a39d57
Content-Type: application/octet-stream; name=FACP
Content-Disposition: attachment; filename=FACP
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxhf3fkf2

RkFDUPQAAAAEk0RFTEwgIENCWDMgICAABCAiBk1TRlQTAAEAQE5+zxgQd88BAAkAsgAAAKChAIAA
BAAAAAAAAAQEAAAAAAAAUAQAAAgEAAAgBAAAAAAAAAQCAQQQAACFZQDpAwAEEAABA31+MhMAAKWG
AwABCAAAZAAAAAAAAAD+AAAAQE1+zwAAAAAYEHfPAAAAAAEgAAAABAAAAAAAAAEAAAAAAAAAAAAA
AAEQAAAEBAAAAAAAAAEAAAAAAAAAAAAAAAEIAABQBAAAAAAAAAEgAAAIBAAAAAAAAAGAAAAgBAAA
AAAAAAEAAAAAAAAAAAAAAA==
--14dae9d2f79e32c50704b6a39d57
Content-Type: application/octet-stream; name=FACS
Content-Disposition: attachment; filename=FACS
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxhf3j4w3

RkFDU0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAA==
--14dae9d2f79e32c50704b6a39d57--
