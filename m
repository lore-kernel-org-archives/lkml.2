Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1JLQ7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:59:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62081 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab1JLQ71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <20111010214148.GB26510@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop> <20111007074904.GC16723@count0.beaverton.ibm.com>
 <20111007160113.GB14201@tango.0pointer.de> <m17h4g2jqy.fsf@fess.ebiederm.org>
 <20111010163140.GA22191@tango.0pointer.de> <m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
 <20111010214148.GB26510@tango.0pointer.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 12 Oct 2011 18:59:07 +0200
Message-ID: <CAPXgP13npxh6UoEtXNiZ+Lhe_QxpO8-7r==WuUXDnNr+sHGXMw@mail.gmail.com>
Subject: Re: Detecting if you are running in a container
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 23:41, Lennart Poettering <mzxreary@0pointer.de> wrote:
> On Mon, 10.10.11 13:59, Eric W. Biederman (ebiederm@xmission.com) wrote:

>> - udev.  All of the kernel interfaces for udev should be supported in
>>   current kernels.  However I believe udev is useless because container
>>   start drops CAP_MKNOD so we can't do evil things.  So I would
>>   recommend basing the startup of udev on presence of CAP_MKNOD.
>
> Using CAP_MKNOD as test here is indeed a good idea. I'll make sure udev
> in a systemd world makes use of that.

Done.

http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=9371e6f3e04b03692c23e392fdf005a08ccf1edb

Thanks,
Kay
