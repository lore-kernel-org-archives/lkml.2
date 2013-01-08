Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3AHOxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:53:48 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:42314 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab3AHOxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:53:47 -0500
Date: Tue, 8 Jan 2013 09:53:46 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: "lin >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [Consult] our latest kernel and latest Android  under arm
 Samsung S5PV210 with yaffs2 file system
Message-ID: <20130108145346.GC27837@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Chen Gang F T <chen.gang.flying.transformer@gmail.com>,
	"lin >> \"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>
References: <50EBF402.5070007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EBF402.5070007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 06:25:06PM +0800, Chen Gang F T wrote:
>     use yaffs2 file system for android
>       it seems yaffs2 is a standard file system for android.
>         for my android HTC phone is also yaffs2 file system.

yaffs2 is not a _standard_ file system for Android.  There may be some
phones which use it, but the much more common is either FAT (for the
older phones) or ext4.  The Google AOSP releases for pretty much all
modern Nexus phones (Galaxy Nexus and newer if I recall correctly,
certainly for GN, N4, N7, etc.) all use ext4.

>   current:
>     I am trying to use our latest kernel (such as next-20130104)
>       can compile from the source code successfully.
>       it has no source code for yaffs2 file system.

So if your existing Android device is using yaffs2, you'll need to
integrate yaffs2, since yaff2 is not in the upstream kernel.  As far
as hardware support, it will depend on the specifics of your
development board, and I'm not enough of an ARM expert to answer that
question.  Others hopefully on this list will be able to answer it.

Regards,

					- Ted
