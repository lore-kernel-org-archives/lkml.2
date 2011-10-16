Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1JPAti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 20:49:38 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:59715 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1JPAth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 20:49:37 -0400
Message-ID: <4E9A2A1C.5010903@linux.vnet.ibm.com>
Date: Sun, 16 Oct 2011 06:19:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jim Faulkner <jfaulkne@ccs.neu.edu>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Bug: Dell Latitude E6400: reboot hangs when system has been	suspended
References: <20111015234748.GA12232@alumni-linux.ccs.neu.edu>
In-Reply-To: <20111015234748.GA12232@alumni-linux.ccs.neu.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On 10/16/2011 05:17 AM, Jim Faulkner wrote:
> Hi, rebooting hangs on my Dell Latitude E6400 after the system has been
> suspended.  The system prints "Restarting system" but freezes, and I
> have to hold the power button to shut down the system.
> 
> Rebooting works fine if the system has not been suspended since the
> initial boot.  This bug only happens after the system has been suspended
> to ram since boot.
> 
> I have tried the "reboot=acpi" and "reboot=force" kernel parameters with
> no change in behavior.
> 
> My dmesg and dmidecode output are attached.  Please let me know if you
> need anymore info.

Can you also provide the log of suspend/resume? And did you face any
problems while resuming the system after suspending it?

Also, please CC the linux-pm mailing list (linux-pm@vger.kernel.org) when
reporting suspend related bugs.

-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
