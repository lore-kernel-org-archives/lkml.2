Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1FKJoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 05:44:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab1FKJoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 05:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WdfoYCkFSWAerF23ejxrgm/QqeZ6im22Jcz3d8BA8Opzhi4OTAtLLoEGjoaOX8jWco
         5PJPS/VDjw6bijzFjAAXPCgXo8XsZZfEvIJ1ftz4yIjMajr8DAkv3dG8BQ9brFZkkdxo
         kGIO/u4ZZeotuo+Df3MELELFq5fSHX/aiKRsA=
MIME-Version: 1.0
In-Reply-To: <843433D5F73C864182AC91B8@nimrod.local>
References: <BANLkTimyBGfg4+ovGsiGqpCz345qVmU_7A@mail.gmail.com>
	<BANLkTik20iYN4c9faKD9dzerehazWTwTFw@mail.gmail.com>
	<BANLkTikKRuPu_NX49vr0w-XeN0ZnWo+9vg@mail.gmail.com>
	<alpine.LFD.2.00.1106101101020.4502@dhcp-27-109.brq.redhat.com>
	<20110610101142.GA10144@ubuntu>
	<BANLkTi=zjU3-FV3AVpYsknzKFgaS7byb_Q@mail.gmail.com>
	<20110610150129.GA17585@ubuntu>
	<BANLkTikUZadpVJRcfX_MLMZ-p_G0bT_8uQ@mail.gmail.com>
	<20110611074908.GC2517@ubuntu>
	<843433D5F73C864182AC91B8@nimrod.local>
Date: Sat, 11 Jun 2011 12:44:16 +0300
X-Google-Sender-Auth: p365x9uLYeOtO2FfL9Z7TXoCoag
Message-ID: <BANLkTik8Oac+5Ci7Y9VvNUqv-DaYmPkWZA@mail.gmail.com>
Subject: Re: LVM vs. Ext4 snapshots (was: [PATCH v1 00/30] Ext4 snapshots)
From: "Amir G." <amir73il@users.sourceforge.net>
To: Alex Bligh <alex@alex.org.uk>
Cc: Joe Thornber <thornber@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu, linux-kernel@vger.kernel.org, lvm-devel@redhat.com,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 11:18 AM, Alex Bligh <alex@alex.org.uk> wrote:
>
>
> --On 11 June 2011 08:49:08 +0100 Joe Thornber <thornber@redhat.com> wrote:
>
>> I am also convinced multisnap wont be suitable for every use case.
>
> I'm surprised by one thing ext 4 snapshots doesn't seem to do: I would have
> thought the "killer feature" for doing snapshots in the fs rather than in
> the block layer would be the ability to snapshot - and more importantly
> roll back - only parts of the directory hierarchy.
>
> (I've only read the URLs Amir sent, so apologies if I've missed this)
>

No need for apologies.
There is no per-directory snapshot nor rollback with ext4 snpshots.
It is possible to configure a part of the directory hierarchy to be excluded
from future snapshots, but not to delete it selectively from past snapshots.

Amir.
