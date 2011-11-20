Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1KTDgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 22:36:09 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:60928 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab1KTDgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 22:36:08 -0500
Date: Sat, 19 Nov 2011 22:35:34 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: David Rientjes <rientjes@google.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] ext4: group info caches set to SLAB_MEM_SPREAD flags.
Message-ID: <20111120033534.GH4130@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Rientjes <rientjes@google.com>,
	Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
References: <1321742924-3189-1-git-send-email-linkinjeon@gmail.com>
 <alpine.DEB.2.00.1111191524200.5986@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111191524200.5986@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 03:29:34PM -0800, David Rientjes wrote:
> If there is convincing data that suggests it's helpful on your hardware, 
> then it would make a good case to merge your patch so users don't need to 
> set their own mempolicies that do this.  They'll just need to mount 
> cpusets and enable cpuset.memory_spread_slab.

>From Namjae and Amit have stated, they don't have access to any NUMA
hardware.  If I had to guess they are students or people who are
trying to start a Linux development team at some company or research
institute, and have decided to start by sending cleanup patches.

	       	    	       	     	- Ted
