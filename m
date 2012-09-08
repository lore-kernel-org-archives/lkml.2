Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2IHSk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:40:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60312 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2IHSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:40:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120908233455.0d0527b3@feng-i7>
References: <20120731235705.GW2422@linux.vnet.ibm.com>
	<1343779778.27983.73.camel@gandalf.stny.rr.com>
	<20120801001811.GX2422@linux.vnet.ibm.com>
	<20120801004319.GA7043@localhost>
	<20120822025008.GA8066@localhost>
	<20120822154908.2e6ef3c0@feng-i7>
	<CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
	<20120823154503.15a45b14@feng-i7>
	<CAE9FiQVXj6sLEs0GiBnVsKAbms-Bnt06xYeT01MBtSjNqaqypA@mail.gmail.com>
	<CAE9FiQU2sqXLyMg2KbdKQBaX8WDeagd=OmZ5ELhYgkUQ4b6jZA@mail.gmail.com>
	<20120908134220.GA24831@localhost>
	<20120908233455.0d0527b3@feng-i7>
Date: Sat, 8 Sep 2012 11:40:52 -0700
X-Google-Sender-Auth: 0y5zWfrpy6MtxvXl9weBROuLCjU
Message-ID: <CAE9FiQU1MxyRvYapi35j5_N7Ob7rnPTYNcvDbMYcSy9VNmaz=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: Use local parameter pci_device_id for pci_get_subsys/class()
From: Yinghai Lu <yinghai@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 8:34 AM, Feng Tang <feng.tang@intel.com> wrote:
>> This makes lspci work again on my side. The caveat is, kzalloc() will
>> zero out all data while the new local variable leaves some data
>> uninitialized.
>
> Yes, thanks for the quick root cause and fix to the bug in my code.

Can you resubmit your patch with two extra "memset" line?

Thanks

Yinghai
