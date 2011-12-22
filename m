Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1LVRct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:32:49 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40356 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1LVRcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAOh0hwPGzx64gt=ohbWQL96F28ZXEy_y4XF1YRHyKEctT1-sCg@mail.gmail.com>
References: <CAOh0hwO03GJ2ApNW6GV5fJKJ4S+hTv3An7vLTO4qaL4U9grdJg@mail.gmail.com>
	<CAFLxGvyWWCAfk-fCCc3NhCE=KbE-Y7ivO5gynSbCubxPC8d-uw@mail.gmail.com>
	<CAOh0hwOpzXRp9k70qK6rWURE5414c0=A2ALEBtL=77xxDW9hiw@mail.gmail.com>
	<CAFLxGvxQ0E+j1LHfN3fCMM_TVqV6QG3B=VQiy1FPGdn5senBDw@mail.gmail.com>
	<CAOh0hwPGzx64gt=ohbWQL96F28ZXEy_y4XF1YRHyKEctT1-sCg@mail.gmail.com>
Date: Thu, 22 Dec 2011 18:32:45 +0100
Message-ID: <CAFLxGvyR9-u+bEKdhSVq7C+NQ+=8hbfwTeL6KK9D3mSx4E9qNg@mail.gmail.com>
Subject: Re: Intercepting system calls
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Gaurav Saxena <grvsaxena419@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 6:16 PM, Gaurav Saxena <grvsaxena419@gmail.com> wrote:
> I want to monitor whole / and its sub directories for unlink call, if
> there is any call I would save the file, would it be possible with
> FUSE? It would require remounting of file system ? I don't think
> ptrace would be of help as applications are not under my control.

This is a non-trivial problem.
Consider also using a stackable filesystem like dazuko
(http://dazuko.dnsalias.org)

-- 
Thanks,
//richard
