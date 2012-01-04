Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2ADFln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:41:43 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58608 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2ADFlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:41:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] sysfs:  Reduce the size of sysfs_dirent
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
Date: Tue, 03 Jan 2012 21:43:47 -0800
In-Reply-To: <m1aa6pky2r.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Sun, 18 Dec 2011 20:03:08 -0800")
Message-ID: <m1sjjwggz0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18yyL55CeLSuuRiYZWwq9rDrmRpAJi19fk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> After throwing rb_trees at the problem sysfs_dirent increased in size by
> 6 pointers, or 48 bytes.    Since the point of having struct
> sysfs_dirent is to keep the size down increasing in size that much seems
> unfortunate.
>
> The following patches attack this problem and if I have counted right
> reduce the size of sysfs_dirent by 4 pointers on 64bit.  Not quite
> where we were but reducing sysfs_dirent by 32bytes to 104 bytes is
> an improvement.

Greg did you see these patches for reducing the sysfs memory size
regression in 3.2?

Eric
