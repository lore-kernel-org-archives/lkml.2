Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1KIXOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 18:14:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:43676 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab1KIXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 18:14:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="88245361"
Date: Wed, 9 Nov 2011 23:25:53 +0000
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 01/10] TTY: serial, cleanup include file
Message-ID: <20111109232553.5fa24741@bob.linux.org.uk>
In-Reply-To: <4EBAFA03.40405@suse.cz>
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz>
	<20111109215901.16f44570@bob.linux.org.uk>
	<4EBAFA03.40405@suse.cz>
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

On Wed, 09 Nov 2011 23:09:07 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> On 11/09/2011 10:59 PM, Alan Cox wrote:
> > We need to move the tty_buffer objects into the tty_port.
> 
> Thanks a lot for reminding me. (I remember you telling me about this
> at KS.) So I suppose you prefer this to be done first... OK, I will
> look into that. Leaving the rest of the serial stuff apart for the
> time being.

I'm not really bothered what is done first - it's not as if I am doing
the work! I just thought it might be easier to do it that way around
rather than adding and removing more complexity on the way ?

Alan
