Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1BOFyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:54:32 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49046 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1BOFyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:54:31 -0500
Date: Tue, 15 Feb 2011 11:24:26 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: Mapping memory between kernel and user space
Message-ID: <20110215055426.GA468@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <AANLkTi=Ca4Lcc_war-atpr81eJcZA3ks+EKFf9Rq5pKs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Ca4Lcc_war-atpr81eJcZA3ks+EKFf9Rq5pKs@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 06:45:42PM -0500, Sri Ram Vemulpali wrote:
> Hi all,
> 
>   How do I map some space between kernel and user space. Can anyone
> point me in to right direction. I was trying to map the packets from
> my netfilter function to kernel user space, to avoid over head of
> copying. Thanks in advance.
>

You can take a look at remap_pfn_range() routine when implementing mmap
in your driver.
 
-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
