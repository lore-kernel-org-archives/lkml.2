Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab2EaTGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:06:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395Ab2EaTGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <1338466675.3073.21.camel@dabdike.int.hansenpartnership.com>
References: <1338466675.3073.21.camel@dabdike.int.hansenpartnership.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 May 2012 12:05:45 -0700
X-Google-Sender-Auth: l1BshSVFcyE2cyE0EafXCUXtYms
Message-ID: <CA+55aFxvmsCq7htqAZfVk69=YFXvu8e8kS+misSEMBCE4exmrA@mail.gmail.com>
Subject: Re: [GIT PULL] Final round of SCSI updates for the 3.4+ merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 5:17 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

No it's not. You used some stale old name. It's "scsi.git", not
"scsi-misc-2.6.git".

Also, wouldn't it be much nicer if the tag actually contained your
useful comments, rather than just the useless date.

But pulled.

          Linus
