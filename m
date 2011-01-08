Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1AHJOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 04:14:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52408 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1AHJOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 04:14:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=wrvZx1K5fohQdYn6rG457bkDXplgCO5NbjL1xLGEC2EKTx6eBvuVJBv5yptBel0NMd
         dqYJ9AFS1C1MFZ6rxWcOQQ53T75G4w+CAD/V+ERDUQFbhKuv/DusSO+/Nkk8tkBISuEJ
         BmH9LKMWzhIN5fWmMISm8nd5HBT8CpdmSpgYM=
Message-ID: <4D282A17.4040104@gmail.com>
Date: Sat, 08 Jan 2011 10:10:47 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Nick Piggin <npiggin@gmail.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Important for fs devs: rcu-walk merged upstream
References: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
In-Reply-To: <AANLkTimBrR1LkVHOxZA=UUmKsnxfsFLr9z_AhXUHQ_7N@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/01/2011 03:54, Nick Piggin ha scritto:
> The vfs-scale branch is now upstream. If you haven't
> looked yet, your filesystem is likely to have been
> touched, so check it out.
> 
> Also look at Documentation/filesystems/porting and
> path-lookup.txt.

Nick, in the porting file I read:

..........hazards on dentries and inodes (see
Documentation/filesystems/path-walk.txt). ..........
 ^^^^^^^^^^^^^

Should it be "path-lookup.txt"?

Marco
