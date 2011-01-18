Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1ARMr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 07:47:57 -0500
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:55060 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab1ARMr4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 07:47:56 -0500
X-AuditID: 1209190d-b7cacae000000a14-c1-4d358bfbadb3
Subject: Re: Inode - Kernel Mode
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTimYSyzuZrWXDsW1kxB=QD_4ua01csLv760zwZ-b@mail.gmail.com>
Date: Tue, 18 Jan 2011 07:47:53 -0500
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A8E9D047-55C8-4B41-98E6-D99BBA230CCB@mit.edu>
References: <AANLkTimYSyzuZrWXDsW1kxB=QD_4ua01csLv760zwZ-b@mail.gmail.com>
To: Artur Baruchi <mail.baruchi@gmail.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18, 2011, at 5:28 AM, Artur Baruchi wrote:

> Hi Guys.
> 
> I'm able to get the inode number for a given file. Is there a way to
> get the file size, since I already have the inode ?

Not in a portable / file system independent way.

In Linux, file systems are not required to use inode numbers at all.

See:  http://www.openafs.org/pipermail/openafs-devel/2008-February/015805.html

-- Ted

