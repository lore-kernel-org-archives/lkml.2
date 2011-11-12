Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1KLMqX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 07:46:23 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:53590 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1KLMqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 07:46:22 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Tomas M." <tmezzadra@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com,
        Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
References: <4EBD46DF.6060507@gmail.com> <4EBD9500.8070204@gmail.com>
	<201111120141.48463.rjw@sisk.pl> <201111120250.14151.rjw@sisk.pl>
Date: Sat, 12 Nov 2011 13:45:56 +0100
In-Reply-To: <201111120250.14151.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 12 Nov 2011 02:50:13 +0100")
Message-ID: <87k475cxvf.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday, November 12, 2011, Rafael J. Wysocki wrote:
>> On Friday, November 11, 2011, Tomas M. wrote:
>>> yes, that helps.
>> 
>> What does "cat /sys/devices/system/cpu/cpuidle/current_driver" show?
>
> If that's "acpi_idle", the appended patch should help (it works for
> me at least).

It works for me, too.
-- 
Thanks,
Feri.
