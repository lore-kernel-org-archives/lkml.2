Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1K2Gn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:43:58 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:33360 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1K2Gn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:43:57 -0500
Date: Tue, 29 Nov 2011 12:12:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stan Shebs <stanshebs@earthlink.net>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH] Kernel module for global breakpoints
Message-ID: <20111129064213.GA11287@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <4ED41CF7.8080002@earthlink.net>
 <m239d76b0y.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <m239d76b0y.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112906-5518-0000-0000-000000AC3598
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Any and all comments appreciated! (even "this is a stupid idea"
> > reactions :-) )
> 
> Isn't this doing what uprobes does? Perhaps you just need a new user
> interface to uprobes.

Right, this is something similar to what uprobes is doing.
Currently these breakpoints arent exported to debuggers and can be used
thro perf probe. However we do have plans to have a systemcall that
uses uprobes and allows the debuggers to insert breakpoints.

Currently, We have a high level overview of how to provide the syscall
interface.  Do let me know if you are interested in contributing to the
sys-call interface for uprobes.

Please try the for-next branch at git://github.com/srikard/linux.git.
Uprobes is also available on current linux-next tree.

-- 
Thanks and Regards
Srikar

