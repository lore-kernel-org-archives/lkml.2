Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab1KHRzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:55:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56518 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1KHRzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:55:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111106183851.GA4339@shiny>
References: <20111106183851.GA4339@shiny>
Date: Tue, 8 Nov 2011 12:55:40 -0500
Message-ID: <CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
From: Dan Merillat <dan.merillat@gmail.com>
To: Chris Mason <chris.mason@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.com> wrote:
> Hi everyone,
>
> This pull request is pretty beefy, it ended up merging a number of long
> running projects and cleanup queues.  I've got btrfs patches in the new
> kernel.org btrfs repo.  There are two different branches with the same
> changes.  for-linus is against 3.1 and has also been tested against
> Linus' tree as of yesterday.

[91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
[91795.123538] btrfs: open_ctree failed

FS created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
whenI tried to mount on 3.1 (x64) again.  Format change in 3.2 or
32/64 bit compatibility issues?
