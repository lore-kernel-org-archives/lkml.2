Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab2IKTFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:05:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759811Ab2IKTFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:05:49 -0400
Date: Tue, 11 Sep 2012 16:03:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: qemu-kvm loops after kernel udpate
Message-ID: <20120911190303.GA3626@amt.cnet>
References: <504F7ED8.1030702@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504F7ED8.1030702@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 08:11:36PM +0200, Jiri Slaby wrote:
> Hi,
> 
> it looks like an update from next-20120824 to next-20120910 makes kvm
> defunct. When I try to run qemu, it loops forever without printing
> anything on the monitor.
> 
> -no-kvm makes it indeed work.
> 
> Cmdline I use:
> qemu-kvm -k en-us -usbdevice tablet -balloon virtio -hda IMAGE -smp 2 -m
> 1000M -net user -net nic,model=e1000 -usb -serial pty
> 
> Before I start investigating further, like biscection, is this a known
> issue already and fix available somewhere?
> 
> thanks,

Its not a known issue. 'info registers' (for both vcpus) and
'x /20i $eip' might help track it down. 

