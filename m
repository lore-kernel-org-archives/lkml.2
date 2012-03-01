Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966308Ab2CANuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:50:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52117 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab2CANuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:50:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.70.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<CADDYkjRni4i3QvWo+hOn-Ct4mFoTpL1-ydmE7fbzYJmHFhS3_Q@mail.gmail.com>
	<CADDYkjRYrKaBvTQ4Pe6bfemL7r5W=AU468uy0krFAEJD45syow@mail.gmail.com>
	<20120229144244.GF5054@shiny>
	<CADDYkjSEcktUYS+FzoEQ-FH1yMCvq4as5S2LoJyQBPM9=+CoTw@mail.gmail.com>
	<CADDYkjQ-N2+2sJMb9=DZt1vr1=nWkCCdXB2xJAPgkhAuguEPyg@mail.gmail.com>
Date: Thu, 1 Mar 2012 21:50:10 +0800
Message-ID: <CAJd=RBAs3KGVO8hdUY3peoG1JuxU7_SZ4Z=H0Uy43wLpUFkh7g@mail.gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
From: Hillf Danton <dhillf@gmail.com>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        lczerner@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 9:35 PM, Jacek Luczak <difrost.kernel@gmail.com> wrote:
>
> While I was about to grab acp I've noticed seekwatcher with made my day :)
>
> seekwatcher run of tar cf to eliminate writes (all done on 3.2.7):
> 1) btrfs: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs.png
> 2) ext4: http://dozzie.jarowit.net/~dozzie/luczajac/tar_ext4.png
> 3) both merged: http://dozzie.jarowit.net/~dozzie/luczajac/tar_btrfs_ext4.png
>
> I will send acp results soon.
>
Would you please take reiserfs into account?

Thanks
-hd
