Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0C2QaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:30:13 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:49364 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202Ab0C2QaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:30:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fkKnOSgU4TysMFtjO6CoMnYj36C98BKP3Q/vXmzf1ZK58jw501FMVMb/Ngt473jgHi
         wj5MRF9MsFzrCCCSGYNXrCzLJ3OQytCW1CRQ/5g63Tt342v86AqLbwTjA/ic9wTKuyY9
         bk93nykkY70dP5t4VrJ/fCYdslYb2dy5ITP7g=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1003291208570.24576@pobox.suse.cz>
References: <1267362296-29079-1-git-send-email-mfwitten@gmail.com> 
	<201003291456.53387.rusty@rustcorp.com.au> <alpine.LNX.2.00.1003291208570.24576@pobox.suse.cz>
From: Michael Witten <mfwitten@gmail.com>
Date: Mon, 29 Mar 2010 10:29:49 -0600
Message-ID: <b4087cc51003290929r157257f2k2de2c805ff76ca74@mail.gmail.com>
Subject: Re: [PATCH 00/25] Overview: Docs: kernel-hacking
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 04:09, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 29 Mar 2010, Rusty Russell wrote:
>
>> > I recently read through Rusty Russell's
>> >
>> >     Unreliable Guide To Hacking The Linux Kernel
>> >
>> > and made changes along the way.
>> >
>> > Though there are 25 patches in this series, most provide
>> > extremely minor modifications.
>>
>> It's good to see someone applying some much needed attention to these; they
>> look fine at first glance; is Jiri happy to take them?
>
> Hi,
>
> according to Randy, this is already queued in his linux-doc tree.

Actually, I put a halt to that patch series, and I'm working on a more
comprehensive version.
