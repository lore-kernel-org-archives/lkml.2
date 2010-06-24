Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0FXOsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:48:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51260 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab0FXOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:48:28 -0400
To: Andrew Lutomirski <luto@mit.edu>
CC: miklos@szeredi.hu, npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       drepper@redhat.com, torvalds@linux-foundation.org
In-reply-to: <AANLkTikKTtNlWEgAL1s2uxIFDPZWn2FDYDQg96mpDsv8@mail.gmail.com>
	(message from Andrew Lutomirski on Thu, 24 Jun 2010 10:37:31 -0400)
Subject: Re: [rfc] new stat*fs-like syscall?
References: <20100624131455.GA10441@laptop> <4C2366F7.5010200@mit.edu> 
	<E1ORnGc-0008CL-Uo@pomaz-ex.szeredi.hu> <AANLkTikKTtNlWEgAL1s2uxIFDPZWn2FDYDQg96mpDsv8@mail.gmail.com>
Message-Id: <E1ORnj2-0008JJ-PN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Jun 2010 16:48:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010, Andrew Lutomirski wrote:
> Wasn't the point that /proc/self/mounts (and presumably
> /proc/self/mountinfo) isn't scalable and we wanted a syscall to query
> it efficiently (and racelessly)?

The question was how to support statvfs() efficiently, and the only
thing missing there is f_flags which can easily be added to the
existing statfs() syscall.

A separate mount_info() syscall might possibly be useful, but that's
another story.

Thanks,
Miklos
