Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2AJShX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:37:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59657 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2AJShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:37:21 -0500
MIME-Version: 1.0
In-Reply-To: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
References: <1325801944.2775.32.camel@dabdike.Larkspurhotels.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 10:36:59 -0800
X-Google-Sender-Auth: OrO7tKBcDAH7MXCKgwNFC5JXdp4
Message-ID: <CA+55aFzR7Qvhoo9QVy-0RzPkqQ=J-DBpLurYSV7azMbQGOJchg@mail.gmail.com>
Subject: Re: [GIT PULL] Next round of SCSI updates for 3.2 merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 2:19 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git#scsi-misc

No it's not.

Please fix your crappy script.

First off, that '#' is wrong. It should be a space.

Secondly, "master.kernel.org" doesn't support ssh'ing into it any
more, and can't be used the way you claim I should use it.

IOW, that thing should have been

  git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

so please fix your script to do that,

                   Linus
