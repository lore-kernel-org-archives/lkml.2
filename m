Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1KXJMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:12:43 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:55626 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab1KXJMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:12:39 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com> <4e3c37a6-3777-4138-800b-f055f7caa8f3@email.android.com> <1322124881.4248.8.camel@lappy>
User-Agent: K-9 Mail for Android
In-Reply-To: <1322124881.4248.8.camel@lappy>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] iio: Fix build error in industrialio-core.c
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Thu, 24 Nov 2011 09:11:48 +0000
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org
Message-ID: <44607571-8d2b-4425-bfea-10e18900b963@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sasha Levin <levinsasha928@gmail.com> wrote:

>On Thu, 2011-11-24 at 08:49 +0000, Jonathan Cameron wrote:
>> 
>> Sasha Levin <levinsasha928@gmail.com> wrote:
>> 
>> >The error was introduced in commit b4641336 ("iio: fix a leak due to
>> >improper use of anon_inode_getfd()").
>> >
>> >Looks like the code wasn't even compile tested. Instead of just
>fixing
>> >the
>> >error I changed the function a bit to make it nicer.
>> Minimal change would have been slightly nicer but clean up is obvious
>so fine. Thanks for doing this.  Andrew m has a dirty build fix in NM
>but he will drop that when this hits.
>
>If you'd like I can split it into two patches, the fix and the cleanup.

Unless Greg wants that don't bother. I just want the fix in place!
>-- 
>
>Sasha.

-- 
Sent from my Android phone 
with K-9 Mail. Please excuse my brevity.
