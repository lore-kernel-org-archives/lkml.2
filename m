Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2KFWHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:07:25 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:38859 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab2KFWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:07:22 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Chris Friesen <chris.friesen@genband.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com> <87625iwgao.fsf@mid.deneb.enyo.de>
	<7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
Date: Tue, 06 Nov 2012 23:06:56 +0100
In-Reply-To: <7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com> (Matthew
	Garrett's message of "Tue, 06 Nov 2012 16:55:25 -0500")
Message-ID: <87fw4mv11b.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> I'm not sure why you think that Fedora PXE installs will
> automatically wipe disks - they'll do whatever Kickstart tells them
> to do.

Or what the referenced initrd contains (which is not signed, for
obvious reasons).  The point is that "the bootloader is signed by
Fedora" does not translate to "I can run this without worries".

I'm not sure if anybody has made promises in this direction.  But lack
of a "do no harm" rule (which would have to prevent certain forms of
unattended installation for sure) means that we do not get that many
benefits out of Secure Boot.
