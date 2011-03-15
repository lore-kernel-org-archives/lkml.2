Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab1COQOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:14:17 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:38495 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758140Ab1COQOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:14:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EKHBZt3Z1EtuWiycwJscLix6fic9YeGcPy9WntCxJ/AWjK7mOmnKDwW7biQc8wmM8TdKzr/lNbCdAdYFttvmdAv0AOxqCDeyczV+NE8rrKNcb1fgnf8gH5Hq2ykC/C5M;
Date: Tue, 15 Mar 2011 09:14:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aneesh Bhasin <contact.aneesh@gmail.com>
Cc: linux-newbie <linux-newbie@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: smap output - unnamed entries and heap
Message-Id: <20110315091412.de6eb63c.rdunlap@xenotime.net>
In-Reply-To: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com>
References: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 14:31:50 +0530 Aneesh Bhasin wrote:

> Hi All,
> 
> My apologies if this is not the right place for these type of
> questions - I do not know of a better place to ask this.
> 
> I am trying to take out some memory figures from the /proc/<pid>/smaps
> interface (linux v2.6.35). However, I could not find what do the
> entries that have no name associated to them (no library path or
> binary path with these entries) mean. So, I wrote a test C program
> that allocates 100MB of memory (using malloc) and then writes to it in
> chunks of 10MB. I could see that the 'Size' and 'RSS' of one of the
> unnamed entries was increasing in accordance with the code, but there
> were several other such unnamed sections too - is there a way to know
> what and where do they come from.
> 
> Also, I could see that for some process the smap interface was showing
> a '[heap]' entry but not for all - e.g. for my above test case, there
> was no '[heap]' entry, although I assumed the malloc should have
> reflected in the [heap]. Can someone please tell me (or point me in
> the right direction) why is heap entry there only for some processes ?
> 
> Thanks in advance for any help..

Did you look at Documentation/filesystems/proc.txt ?
It has some info on smaps and maps.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
