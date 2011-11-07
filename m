Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1KGOjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:39:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:57829 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648Ab1KGOjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:39:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,470,1315206000"; 
   d="scan'208";a="87046860"
Date: Mon, 7 Nov 2011 14:50:05 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function
 flush_to_ldisc().
Message-ID: <20111107145005.68ca1050@bob.linux.org.uk>
In-Reply-To: <4EB7E0C6.7050909@ilyx.ru>
References: <4EB7BD9A.7070600@ilyx.ru>
	<20111107115802.23201d45@bob.linux.org.uk>
	<4EB7CCFF.5090304@ilyx.ru>
	<20111107130643.07e84fca@bob.linux.org.uk>
	<4EB7E0C6.7050909@ilyx.ru>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course I know about tty_buffer_flush(), it only read TTY_FLUSHING,
> it can't change TTY_FLUSHING, if flush_to_ldisc() single threaded,
> we can change TTY_FLUSHING only in one place in one time(in
> flush_to_ldisc()), therefor we can use only "set_bit(TTY_FLUSHING,
> &tty->flags)" without test.

Yes.. if you can pin down why in your testing you see the other case
sometimes being true.

Alan
 

