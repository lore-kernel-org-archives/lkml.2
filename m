Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2JCDqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:46:34 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58762 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab2JCDqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:46:33 -0400
Message-ID: <506BB50E.7090707@cs.wisc.edu>
Date: Tue, 02 Oct 2012 22:46:22 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jonathan McDowell <noodles@earth.li>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Soft lockup in scsi_remove_target under 3.6 (regression from
 3.5)
References: <20121003004309.GA2289@earth.li>
In-Reply-To: <20121003004309.GA2289@earth.li>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 07:43 PM, Jonathan McDowell wrote:
> Upgraded to 3.6 today on my dev box and after seeing an FC attached SAN
> go down and come back up (due to an expected reboot) I started getting
> the following in my logs. It continues even after the array is back and
> functioning - I'm seeing:
> 
>  kernel:[109104.348034] BUG: soft lockup - CPU#6 stuck for 23s!
> [kworker/6:0:30692]
> 
> repeated on logged in sessions and backtraces like the following (this
> is the first). I don't see the same problem under 3.5.
> 


I think you need this patch
http://marc.info/?l=linux-scsi&m=134621716223056&w=2
