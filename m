Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab1ELOtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:49:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43965 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1ELOtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=unoATwGex/V3Vhd/iXUPhwM/W4n0ngBGq+prl195CnlNomTxUB0fn0ksnjCv0s1FCB
         eqCIKgsThxAURCf7Kp2Id+2qrl068SJ0BHfcDIhXC4bKTKFCMKXNVfxPROOC4Oc2S86n
         aKQxHdDaZiJ22dwZxbYlRQqqQCnTlngrKFZaY=
MIME-Version: 1.0
In-Reply-To: <BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	<BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	<BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
Date: Thu, 12 May 2011 22:49:47 +0800
Message-ID: <BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: ttlxzz ccc <boyzccc@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 10:33 PM, ttlxzz ccc <boyzccc@gmail.com> wrote:
> Thanks for Wangcong
>
> I have test the kmemleak-test.ko and the result includes no backtrace
> except fffffffff, too.
> I'm compling the kernel by make menuconfig. :)

Odd, this looks like a bug, Cc Catalin Marinas <catalin.marinas@arm.com>

I can't reach my test machine right now, I will try this tomorrow.
