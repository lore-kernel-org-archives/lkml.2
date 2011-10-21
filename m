Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1JULE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:04:26 -0400
Received: from spaceboyz.net ([87.106.131.203]:52882 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab1JULEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:04:25 -0400
Date: Fri, 21 Oct 2011 13:04:18 +0200
From: David Lamparter <equinox@diac24.net>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH][RFC] ipconfig: Add new kernel parameter to force MAC
 address
Message-ID: <20111021110418.GG651279@jupiter.n2.diac24.net>
References: <878vofr2t9.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vofr2t9.fsf@elisp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:27:30AM +0900, Naohiro Aota wrote:
> However it's not possible when you are using NFS root since the
> kernel already set the random MAC address and you cannot change
> it after system boot up process.

Is there any particular reason you're not using an initramfs?
Kernel autoconfiguration & NFS-root are relicts of old times, with an
initramfs you can start a proper portmap/rpcbind daemon and use full
regular NFS (v4 even).

... and you can change the MAC before bringing the interface up.


-David
