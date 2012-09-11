Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2IKSLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:11:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60237 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab2IKSLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:11:40 -0400
Message-ID: <504F7ED8.1030702@suse.cz>
Date: Tue, 11 Sep 2012 20:11:36 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: qemu-kvm loops after kernel udpate
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it looks like an update from next-20120824 to next-20120910 makes kvm
defunct. When I try to run qemu, it loops forever without printing
anything on the monitor.

-no-kvm makes it indeed work.

Cmdline I use:
qemu-kvm -k en-us -usbdevice tablet -balloon virtio -hda IMAGE -smp 2 -m
1000M -net user -net nic,model=e1000 -usb -serial pty

Before I start investigating further, like biscection, is this a known
issue already and fix available somewhere?

thanks,
-- 
js
suse labs
