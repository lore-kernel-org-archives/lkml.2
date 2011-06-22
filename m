Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253Ab1FVOak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:30:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60708 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758100Ab1FVOag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:30:36 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19Dr29ocQ1Dkxn43YEuJ+xA97D4Mn6K/uwwk6gRCP
	yNk5kNWHSDXNJ8
From: Sven Joachim <svenjoac@gmx.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: 631255@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Johannes Wiedersich <debian@aktendiener.de>
Subject: Re: Bug#631255: 3.0-rc3: kernel BUG at fs/inode.c:1368!
References: <20110622063624.7374.9343.reportbug@johannes4.fritz.box>
	<1308750980.3093.470.camel@localhost>
Date: Wed, 22 Jun 2011 16:30:34 +0200
In-Reply-To: <1308750980.3093.470.camel__9654.87580183453$1308751219$gmane$org@localhost>
	(Ben Hutchings's message of "Wed, 22 Jun 2011 14:56:20 +0100")
Message-ID: <878vsu3pmd.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 15:56 +0200, Ben Hutchings wrote:

> On Wed, 2011-06-22 at 08:36 +0200, Johannes Wiedersich wrote:
>> Package: linux-2.6
>> Version: 3.0.0~rc3-1~experimental.1
>> Severity: important
>> 
>> 
>> aptitude installing a package triggers a kernel oops. I have no idea,
>> what part of the installation process is to blame, but could try to
>> reproduce, if I would get further instructions. 
> [...]
>
> I assume you haven't seen a similar crash in earlier versions?

This bug is specific to 3.0.0-rc3 and has been fixed in -rc4.

> Also, what type of filesystem where you installing on
> (ext3/ext4/btrfs/xfs...)?

I have seen it on ext4, but it's not really filesystem specific AFAIK.

>> /media/data/mattems/src/linux-2.6-3.0.0~rc3/debian/build/source_amd64_none/fs/inode.c:1368!

Fixed by commit 50338b889dc.

Cheers,
       Sven
