Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2AHSNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 13:13:18 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:47151 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2AHSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 13:13:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] sysfs:  Reduce the size of sysfs_dirent
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
	<m1sjjwggz0.fsf@fess.ebiederm.org> <20120108175645.GC29499@suse.de>
Date: Sun, 08 Jan 2012 10:15:31 -0800
In-Reply-To: <20120108175645.GC29499@suse.de> (Greg KH's message of "Sun, 8
	Jan 2012 09:56:45 -0800")
Message-ID: <m1wr9283i4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/NjrsfTW4rmCdubK4v7jVVcFUjmOK9+7E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Tue, Jan 03, 2012 at 09:43:47PM -0800, Eric W. Biederman wrote:
>> ebiederm@xmission.com (Eric W. Biederman) writes:
>> 
>> > After throwing rb_trees at the problem sysfs_dirent increased in size by
>> > 6 pointers, or 48 bytes.    Since the point of having struct
>> > sysfs_dirent is to keep the size down increasing in size that much seems
>> > unfortunate.
>> >
>> > The following patches attack this problem and if I have counted right
>> > reduce the size of sysfs_dirent by 4 pointers on 64bit.  Not quite
>> > where we were but reducing sysfs_dirent by 32bytes to 104 bytes is
>> > an improvement.
>> 
>> Greg did you see these patches for reducing the sysfs memory size
>> regression in 3.2?
>
> Ok, due to the holidays, these ended up missing the 3.3 merge window,
> I'll queue them up for 3.4.

Thanks.

Eric
