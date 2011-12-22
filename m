Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab1LVRh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:37:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55713 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab1LVRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:37:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyR9-u+bEKdhSVq7C+NQ+=8hbfwTeL6KK9D3mSx4E9qNg@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
 <CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
 <CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
 <CAFLxGvxQ0E+j1LHfN3fCMM_TVqV6QG3B=VQiy1FPGdn5senBDw@mail.gmail.com>
 <CAOh0hwPGzx64gt=ohbWQL96F28ZXEy_y4XF1YRHyKEctT1-sCg@mail.gmail.com> <CAFLxGvyR9-u+bEKdhSVq7C+NQ+=8hbfwTeL6KK9D3mSx4E9qNg@mail.gmail.com>
From: Gaurav Saxena <grvsaxena419@gmail.com>
Date: Thu, 22 Dec 2011 23:07:24 +0530
Message-ID: <CAOh0hwMBvQUQ+3KF+FRry-j5NXPFabgio40R-FBwqfa7CwmkjQ@mail.gmail.com>
Subject: Re: Intercepting system calls
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:02 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Dec 22, 2011 at 6:16 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
>> I want to monitor whole / and its sub directories for unlink call, if
>> there is any call I would save the file, would it be possible with
>> FUSE? It would require remounting of file system ? I don't think
>> ptrace would be of help as applications are not under my control.
>
> This is a non-trivial problem.
> Consider also using a stackable filesystem like dazuko
> (http://dazuko.dnsalias.org)
>
> --
> Thanks,
> //richard

Oh Ok. I will surely see this, but as with others like redirfs, it
also doesn't have support for linux >3.0 :(.

-- 
Thanks and Regards ,
Gaurav
