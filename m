Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab2IHB7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:59:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58218 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759992Ab2IHB7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:59:33 -0400
Date: Fri, 7 Sep 2012 18:59:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        linux-pci@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/2] PCI: Use local parameter pci_device_id for
 pci_get_subsys/class()
Message-ID: <20120908015927.GA29784@kroah.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQU2sqXLyMg2KbdKQBaX8WDeagd=OmZ5ELhYgkUQ4b6jZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 06:32:48PM -0700, Yinghai Lu wrote:
> Greg,
> 
> Any reason for using kmalloc instead of local variable during your
> rewriting pci search code?
> 
> commit 95247b57ed844511a212265b45cf9a919753aea1
> Author: Greg Kroah-Hartman <gregkh@suse.de>
> Date:   Wed Feb 13 11:03:58 2008 -0800

Seriously?  Something I wrote 4 years ago?  I really have no idea,
sorry.

greg k-h
