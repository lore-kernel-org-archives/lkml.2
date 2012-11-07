Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab2KGUq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 15:46:28 -0500
Received: from edge.cmeerw.net ([84.200.12.152]:35511 "EHLO edge.cmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab2KGUqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 15:46:25 -0500
Date: Wed, 7 Nov 2012 21:46:14 +0100
From: Christof Meerwald <cmeerw@cmeerw.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Daniel Mack <zonque@gmail.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting a
 particular website
Message-ID: <20121107204614.GC1404@edge.cmeerw.net>
References: <20121105191336.GA1404@edge.cmeerw.net>
 <Pine.LNX.4.44L0.1211071220230.1175-100000@iolanthe.rowland.org>
 <s5hzk2tfcg8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hzk2tfcg8.wl%tiwai@suse.de>
X-PGP-Key: 1024D/2B10BE68, 1998-06-29
X-PGP-Fingerprint: 0289 5466 C1F5 B03C DBA7  6304 8CAF 9782 2B10 BE68
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 08:19:19PM +0100, Takashi Iwai wrote:
> How about the patch below?  (It's for 3.6, and won't be applied cleanly
> to 3.7, but easy to adapt.)

Thanks, that patch seems to fix the problem.


Christof

-- 

http://cmeerw.org                              sip:cmeerw at cmeerw.org
mailto:cmeerw at cmeerw.org                   xmpp:cmeerw at cmeerw.org
