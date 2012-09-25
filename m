Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2IYL7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:59:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39503 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2IYL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:59:07 -0400
Message-ID: <50619C88.8000204@canonical.com>
Date: Tue, 25 Sep 2012 13:59:04 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com> <50615268.1040805@canonical.com> <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com> <506173A6.2050705@canonical.com> <87ipb2pemt.fsf@xmission.com> <50618F96.1020204@canonical.com> <87sja6nxvt.fsf@xmission.com>
In-Reply-To: <87sja6nxvt.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 25-09-12 13:29, Eric W. Biederman schreef:
> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>
>>> Could you try the following patch?  This should report what directories
>>> cannot be renamed because one of them is a mount point and it gives some
>>> real insight into what is going on.
>> ls /
>> __d_unalias: /dev -> /dev
>> __d_unalias: /proc -> /proc
>> __d_unalias: /sys -> /sys
> Ok.  That is what I thought was going on.  For some reason nfs is
> attempting to recreate an existing dentry.
>
> Does this fix the nfs problem for you?
>
> Eric
>
The patch seems to fix it, thanks!

~Maarten

