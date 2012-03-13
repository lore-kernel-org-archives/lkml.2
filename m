Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2CMV2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:28:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45341 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607Ab2CMV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120313142624.GE29169@redhat.com>
References: <5535e246-b7c0-4f69-a27b-1abbadd42db0@zmail14.collab.prod.int.phx2.redhat.com>
	<65a23329-d843-4859-8b7b-430f12882492@zmail14.collab.prod.int.phx2.redhat.com>
	<CAE9FiQU9C=5YAa3DPcx8E9yVckSX5JbLdS=TC90jA8wz1pjzmw@mail.gmail.com>
	<20120313142624.GE29169@redhat.com>
Date: Tue, 13 Mar 2012 14:28:39 -0700
X-Google-Sender-Auth: yrmYjuqLPeGHHx5MJvbJRp5Aavc
Message-ID: <CAE9FiQW8dVoaQj-CcRUAQjV-A+9==bUKLHmzjzBTVZ1NkVoAug@mail.gmail.com>
Subject: Re: crash dump memory reservation regression
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 7:26 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Mar 12, 2012 at 10:31:21PM -0700, Yinghai Lu wrote:
>
>
> So as long as we can reserve till 512MB of kdump memory, that should allow
> us to support up to 6TB of systems with dump filtering. Hopefully that is
> sufficient for quite some time and we don't have to take the path of
> supporting non-contiguous memory for kdump.

one or two years later, there may be x86_system more than 16T?

Yinghai
