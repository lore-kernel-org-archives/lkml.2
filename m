Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab2ITIT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:19:27 -0400
Received: from tee.schottelius.org ([77.109.138.222]:42697 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704Ab2ITITY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:19:24 -0400
Date: Thu, 20 Sep 2012 10:21:02 +0200
From: Nico Schottelius <nico-kernel20120920@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-kernel20120920@schottelius.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: Out of memory on 3.5 kernels
Message-ID: <20120920082102.GB1311@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel20120920@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
References: <20120920060202.GB10758@schottelius.org>
 <alpine.DEB.2.00.1209192351440.30029@chino.kir.corp.google.com>
 <20120920073245.GA1327@schottelius.org>
 <505AC952.60501@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505AC952.60501@broadcom.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.5.4-1-ARCH x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Arend,

Arend van Spriel [Thu, Sep 20, 2012 at 09:44:18AM +0200]:
> Hi Nico,
> 
> Being curious (and suspicious) over here. Are you doing the rsync
> over wireless interface using brcmsmac? I am currently looking at
> bugzilla #47721 (see [1]) and maybe this is related.

No, the rsync actually goes to a local usb disk that is encrypted
with luks.

The only issue with brcmsmac currently is that after suspend & resume,
I've to manually do reassociate - it thinks it is associated, but no
packets are being received by the card (using tshark).

> [1] https://bugzilla.kernel.org/show_bug.cgi?id=47721

Uh, this is ugly. I'll have a look at brcmsmac related messages, before
the kernel buffer fills up again.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
