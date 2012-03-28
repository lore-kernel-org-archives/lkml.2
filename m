Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2C1XqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 19:46:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45435 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab2C1XqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 19:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
References: <E1SCEK7-0008CY-LJ@tytso-glaptop.cam.corp.google.com> <CA+55aFwxWZ9-xLsZoi+iFMjkt-+V64q4jfMz=dampgJrMX5Ncw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Mar 2012 16:45:55 -0700
X-Google-Sender-Auth: ZuLfr3oMfFkODp4BU1fRCtLMQBM
Message-ID: <CA+55aFy+go3EwPeQcdv+kvy3vQ2Qxcoizoap8MFGKqSC42ajFg@mail.gmail.com>
Subject: Re: GIT PULL] ext4 updates for 3.4
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 4:36 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I have no real data for this, though - just a "mouse pointer
> occasionally freezing up". So I'm looking for a potential "hmm, that
> makes me wonder if..." kind of reaction.

Heh. It may have been that my wireless mouse was having some issue
syncing properly with the receiver. I unplugged and replugged the
receiver, and I seem unable to reproduce the problem. So this may have
been just an actual hardware latency issue, rather than the kernel
having bad latency.

But if it made you go "hmm, I should check xyz", please do go ahead
and check it anyway, just in case ;)

                         Linus
