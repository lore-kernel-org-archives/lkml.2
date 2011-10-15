Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab1JOVEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 17:04:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53308 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1JOVEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 17:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <33629.1318706796@turing-police.cc.vt.edu>
References: <4E99A8F3.50206@nod.at> <30236.1318700758@turing-police.cc.vt.edu>
 <4E99C7B7.5060405@nod.at> <33629.1318706796@turing-police.cc.vt.edu>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sat, 15 Oct 2011 17:03:51 -0400
Message-ID: <CAGZ=bqJb5FGJe264TOtfuzm8dyvWO883NFBnzkyA4M6Fe7Nq_g@mail.gmail.com>
Subject: Re: OCFS2 1.6.0 for mainline?
To: Valdis.Kletnieks@vt.edu
Cc: Richard Weinberger <richard@nod.at>, mfasheh@suse.com, jlbec@evilplan.org,
        ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        license-violation@gpl-violations.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 15:26,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 15 Oct 2011 19:49:43 +0200, Richard Weinberger said:
>> Am 15.10.2011 19:45, schrieb Valdis.Kletnieks@vt.edu:
>> > Put differently, why do you think 1.6.0 is available?
>
>> OCFS2 1.6.3-1 and OCFS2 Tools 1.6.3-1 are the latest versions. The new
>> features available in this release include Extended Attributes, POSIX
>> ACLs, REFLINKs, Indexed Directories, Allocation Reservation, Metadata
>> Checksums and User/Group Quotas."
>
> Nice feature list, I can see why you want it. ;)
>
>> Looks like it's only available for "Unbreakable Linux" subscribers.
>> The development seems to be detached from mainline. :-(
>
> Well, you have to admit it *is* an interesting business model - giving release
> N to your customers and N-1 to the world.  I just got totally mislead by the
> quote from the Oracle site that said the development happens in mainline. ;)

If someone who has a copy of Oracle's "Unbreakable Linux" can get
ahold of the sources, please put them in GIT somewhere for the rest of
us to access; it *is* GPLed software after all.  Otherwise, please
distribute the binaries to the rest of us and we will obtain the
sources on our own.  I can't find any published information on their
website about how to obtain the sources, so someone will have to
contact them directly.

In the event that Oracle refuses to provide the sources for OCFS2 to
someone who has been given a copy of the binary then they are
violating the GPL.  A relatively large number of kernel developers not
employed by Oracle have contributed patches to OCFS2, and furthermore
the kernel module appears to exclusively support Linux, indicating
that it is a derivative work Oracle has no rights to relicense.

Cheers,
Kyle Moffett
