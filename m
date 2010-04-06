Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0DFWJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:09:30 -0400
Received: from dm-mail01.mozilla.org ([63.245.208.150]:52622 "EHLO
	dm-mail01.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab0DFWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:09:24 -0400
Message-ID: <4BBBB111.7080804@mozilla.com>
Date: Tue, 06 Apr 2010 15:09:21 -0700
From: Taras Glek <tglek@mozilla.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
References: <4BBA6776.5060804@mozilla.com> <adaljd1790c.fsf@roland-alpha.cisco.com>
In-Reply-To: <adaljd1790c.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 04:52 PM, Roland Dreier wrote:
> Almost certainly teaching my grandmother to suck eggs, but are you aware
> of the work Michael Meeks has done on improving openoffice.org startup time?
>    
Yes. There were some stones left unturned in the cold startup area. 
Turns out that every single large application suffers from low io 
throughput likely due to lack of cooperation between the dynamic linker 
and the kernel.
There is a glibc bug filed on that.

http://sourceware.org/bugzilla/show_bug.cgi?id=11431

Unfortunately, few userspace people seem to know exactly how madvise() 
hints behave, so I was hoping someone on LKML would clue me in.

Taras
