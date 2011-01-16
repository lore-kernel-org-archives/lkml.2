Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1APRz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 12:55:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab1APRzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 12:55:25 -0500
MIME-Version: 1.0
In-Reply-To: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Jan 2011 09:54:31 -0800
Message-ID: <AANLkTikmyDsq37e6D1FXGXTJ7zztsnxfZvPBBHqO_Tch@mail.gmail.com>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 1:10 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
> This patch changes configfs to select SYSFS to fix the following:
>
> warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

I'm ok with this part. But:

> This patch also fixes whitespace breakage in the 'help' section.

This is just bogus. The help text is _supposed_ to have that extra
indentation so that it stands out from the rest of the Kconfig stuff.

                   Linus
