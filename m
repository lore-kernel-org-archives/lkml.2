Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1LDPcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 10:32:24 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39851 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1LDPcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 10:32:20 -0500
Message-ID: <4EDB9276.6070302@linux.vnet.ibm.com>
Date: Sun, 04 Dec 2011 21:02:06 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Patrik Kullman <patrik.kullman@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        michal@ellpspace.math.ualberta.ca, Oliver Neukum <oneukum@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: xhci_hcd: Runtime PM causes port to inactivate
References: <CAGPN=9SQraacGpNJTtsA4NUk8Re1neJaDt42u8HFw8Hg-+n5BQ@mail.gmail.com>
In-Reply-To: <CAGPN=9SQraacGpNJTtsA4NUk8Re1neJaDt42u8HFw8Hg-+n5BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120405-9264-0000-0000-000000549B5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a very similar discussion going on at:
http://thread.gmane.org/gmane.linux.kernel/1222803

Cc'ing all the relevant people and mailing lists.

Regards,
Srivatsa S. Bhat

On 12/04/2011 04:47 PM, Patrik Kullman wrote:

> Issuing
> 
> echo auto > /sys/bus/pci/devices/0000:03:00.0/power/control
> 
> on my Asus Zenbook UX31E with a
> 
> 03:00.0 USB Controller: Fresco Logic Device 1009 (rev 02)
> 
> causes its USB3-port to become mostly disabled.
> 
> It does have a "Charger+" feature that allows it to charge cellphones
> etc even when turned off, and this feature works when power control is
> in "auto" mode.
> 
> In all other aspects, the port is turned off. It doesn't react to
> devices being inserted.
> 
> This does not feel like the desired behavior.
> 
> Also, suspend does not work without unbinding the xhci_hcd module, not
> sure if that is related.
> Computer will not suspend/resume unless the following script is used
> in /etc/pm/sleep.d:
> https://help.ubuntu.com/community/AsusZenbook#Suspend.2C_Hibernate.2C_Shut-down_and_Reboot
> 
> This behavior has not changed between 3.0 and 3.2-rc4+ that I've tried today.


