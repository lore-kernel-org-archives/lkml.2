Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1EYJk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:40:27 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:34707 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1EYJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:40:27 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 11:40:25 +0200
In-Reply-To: <4DDCCC4C.5030606@fusionio.com>
References: <20110519222404.GG12600@redhat.com>
				 <20110521210013.GJ2271@linux.vnet.ibm.com>
				 <20110523152141.GB4019@redhat.com>
				 <20110523153848.GC2310@linux.vnet.ibm.com>
			 <1306189249.15900.10.camel@t41.thuisdomein> <4DDB7D36.60905@fusionio.com>
		 <1306312155.9059.8.camel@t41.thuisdomein> <4DDCC1E4.706@fusionio.com>
	 <1306314848.9059.17.camel@t41.thuisdomein> <4DDCCC4C.5030606@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306316425.9059.23.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 11:30 +0200, Jens Axboe wrote:
> If you build CFQ modular, then all you have to do is switch to using CFQ
> before starting your testing:
> 
> # echo cfq > /sys/block/sda/queue/scheduler
> 
> and switch sda to eg noop before you can remove cfq-iosched again. As
> long as things crash, then you wont be able to remove cfq anyway and you
> have to reboot to test something new anyway. So the modular nature of
> cfq-iosched may not help you all that much in the end.

The main advantage I hope for is to reduce build and install time (it's
much quicker to rebuild a module, copy it into /lib/modules, perhaps
upgrade the initramfs, etc., than it is to rebuild an entire kernel, all
its modules, etc.).


Paul

