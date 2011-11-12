Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1KLMmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 07:42:33 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:53577 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074Ab1KLMmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 07:42:32 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] e978aa7d (cpuidle: Move dev->last_residency update...) broke suspend
References: <874nyadwef.fsf@tac.ki.iif.hu> <201111120218.17758.rjw@sisk.pl>
Date: Sat, 12 Nov 2011 13:42:21 +0100
In-Reply-To: <201111120218.17758.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 12 Nov 2011 02:18:17 +0100")
Message-ID: <87obwhcy1e.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday, November 12, 2011, Ferenc Wagner wrote:
>> Hi,
>> 
>> Since e978aa7d (cpuidle: Move dev->last_residency update to driver
>> enter routine; remove dev->last_state) my ThinkPad R50e can't suspend
>> anymore, it just freezes instead.  I controlled git bisect by booting
>> with break=top and issuing 'echo mem >/sys/power/state'.  My config is
>> attached.
>
> What's the output of "cat /sys/devices/system/cpu/cpuidle/current_driver" ?

acpi_idle.

Your patch (ACPI / cpuidle: Remove acpi_idle_suspend) fixes the problem
for me.  Amazing turnaround, really!
-- 
Thanks,
Feri.
