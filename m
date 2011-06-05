Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1FEWrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 18:47:35 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41111 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab1FEWre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 18:47:34 -0400
Date: Sun, 5 Jun 2011 18:47:32 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Oops fs/ext4/inode.c:2188
Message-ID: <20110605224731.GD1001@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <4DEBD1B4.3000307@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEBD1B4.3000307@odi.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Were there any messages in the syslog before this relating to ext4 or
jbd2?

> Jun  5 20:34:12 box kernel: JBD2: Detected IO errors while flushing file
> data on sdc1-8
> Jun  5 20:34:12 box kernel: Aborting journal on device sdc1-8.
> Jun  5 20:34:12 box kernel: JBD2: I/O error detected when updating
> journal superblock for sdc1-8.

For example, anything like these messages *before* the oops messages?

    	     	      	   	 	  	       - Ted
