Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761205Ab0HFKam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:30:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759247Ab0HFKaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:30:39 -0400
From: Andi Kleen <andi@firstfloor.org>
To: "Berger\, Lutz \(External\)" <Lutz.Berger.External@eads.com>
Cc: <linux-kernel@vger.kernel.org>,
        "Denninghoff\, Sven Dr. \(External\)" 
	<Sven.Denninghoff.External@eads.com>,
        "Maehner\, Herbert \(External\)" <Herbert.Maehner.External@eads.com>
Subject: Re: FW: FW: mq_open
References: <3388F73401504041BD8F7132BAE2C7D41F0812@GSX201B.mxchg.m.corp>
Date: Fri, 06 Aug 2010 12:30:34 +0200
In-Reply-To: <3388F73401504041BD8F7132BAE2C7D41F0812@GSX201B.mxchg.m.corp>
	(Lutz Berger's message of "Fri, 6 Aug 2010 07:42:15 +0200")
Message-ID: <87k4o4c9th.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Berger, Lutz (External)" <Lutz.Berger.External@eads.com> writes:

>  
> Hello gentleman,
>
> we have a problem with 
> mq_open, shm_open and sem_open
>
> As stated in the manpage of "open(2)",  the
>   permissions of the created file are (mode & ~umask).
>
> But what is the use of the mode parameter, it it is not used like the programmers intention?
> On HP Unix or TRU64 the mode parameter is not modified.
>
> Could you please check, if this is a bug or a faulty system design on linux? 

Whatever it is -- it would be dangerous to change because suddenly
ignoring umask could add security problems to existing software.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
