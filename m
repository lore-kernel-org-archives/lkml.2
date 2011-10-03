Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab1JCJj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:39:57 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55597 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab1JCJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:39:50 -0400
Message-ID: <4E8982E3.9080809@linux.vnet.ibm.com>
Date: Mon, 03 Oct 2011 15:09:47 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
CC: ecryptfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Full lockup when compiling kernel with "optimal" number of threads
References: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
In-Reply-To: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 09:04 AM, Pavel Ivanov wrote:
> Hi,
> 
> I can reliably reproduce a complete machine lockup when compiling
> kernel sources with "make -j". After making some progress machine
> stops responding to anything (including CapsLock/NumLock switching or
> mouse moving) and after hard reboot nothing is left in kern.log or
> syslog. Only attaching a serial console gives me the following clues
> to what happens:
> 
By the way "optimal" is supposed to be make -j <nr_cpus*2> isn't it?
IIRC, "maximal" refers to make -j


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
