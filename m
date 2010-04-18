Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0DRHar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 03:30:47 -0400
Received: from omr16.networksolutionsemail.com ([205.178.146.66]:55976 "EHLO
	omr16.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752844Ab0DRHaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 03:30:46 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Apr 2010 03:30:46 EDT
Authentication-Results: cm-omr1 smtp.user=jon; auth=pass (CRAM-MD5)
Message-ID: <4BCAB50C.9030704@nerdgrounds.com>
Date: Sun, 18 Apr 2010 00:30:20 -0700
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: ratheesh k <ratheesh.ksz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: open sockets from task_struct
References: <x2hcfeab66d1004180006ob6ebdba5r489f58f4edafc1a@mail.gmail.com>
In-Reply-To: <x2hcfeab66d1004180006ob6ebdba5r489f58f4edafc1a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(reposted because I remember kernel.org mentioning that HTML email is 
verboten or something like that---Sorry!)

I know that on the user-space side any open handles can be seen in the 
/proc/<pid>/fd directory (<pid> is whatever process you're interested in).
Assuming you're talking about reading this from kernel space, I'd look 
at what the procfs filesystem is doing and learn from that.
Sockets and block/char devices are listed like any other file, the list 
is based on file handles.

> I have task_struct structure , how to find all the opened files ? how
> to find opened sockets ?
>
> Thanks,
> Ratheesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>    

