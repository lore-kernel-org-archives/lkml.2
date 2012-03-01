Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031007Ab2CAOD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:03:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40284 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966290Ab2CAODz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:03:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of difrost.kernel@gmail.com designates 10.213.19.194 as permitted sender) smtp.mail=difrost.kernel@gmail.com; dkim=pass header.i=difrost.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
	<20120229144244.GF5054@shiny>
	<CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
	<CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
	<CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
Date: Thu, 1 Mar 2012 15:03:53 +0100
Message-ID: <CADDYkjR+d+pFYN-mQ91ZP4KcU4zzwC5jmxj1xxMDrp+X+Z8c6g@mail.gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
From: Jacek Luczak <difrost.kernel@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        lczerner@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/1 Hillf Danton <dhillf@gmail.com>:
> On Thu, Mar 1, 2012 at 9:35 PM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
>>
>> While I was about to grab acp I've noticed seekwatcher with made my day :)
>>
>> seekwatcher run of tar cf to eliminate writes (all done on 3.2.7):
>> 1) btrfs: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs.png
>> 2) ext4: http://dozzie.jarowit.net/~dozzie/luczajac/tar_ext4.png
>> 3) both merged: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs_ext4.png
>>
>> I will send acp results soon.
>>
> Would you please take reiserfs into account?

As of now not (lack of time) but I'm pretty close to consider XFS in
the game. Whenever I will have more time and there won't be a pressure
on giving host back to production I will redo same tests for reiserfs.

Now I'm focused on the userspace sorting results.

-Jacek
