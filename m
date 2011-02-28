Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab1B1HDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 02:03:42 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41810 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1B1HDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 02:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sC+fFd00WHLw0pVO6z17hBdv9yS8uv+wrTYwX2srUmC1pyLQEycP989I54qbvYNnr9
         ZIT2pRM0ojwWMZT1FYQ3WSSX97BGqD40N7qleOGFi7NmmiE4BrTL4ada2oO12+oSxS1W
         mO21zQj/LZ7LFSrIMXg6soz5kYEetNOE8ayxY=
MIME-Version: 1.0
Date: Mon, 28 Feb 2011 15:03:40 +0800
Message-ID: <AANLkTimyu6A=LgF8pit6So6JkPrScFLB42U3NwBJq7mv@mail.gmail.com>
Subject: ext2/3/4: punch support?
From: Dave Young <hidave.darkstar@gmail.com>
To: josef@redhat.com
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, josef and ext guys

Do you have any plan with ext4 hole punching support? And the
fallocate for ext2/3?

What's the obstacle to work on this? could someone tell the status of
this issue?

-- 
Regards
dave
