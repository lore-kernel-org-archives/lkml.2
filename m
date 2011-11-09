Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab1KIPyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 10:54:17 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:47857 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1KIPyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 10:54:15 -0500
Date: Wed, 9 Nov 2011 16:54:11 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111109155411.GA1669@nomi.cz>
References: <20111029171554.GA16596@nomi.cz> <20111031160342.GB2225@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111031160342.GB2225@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stanislaw,

On Mon, Oct 31, 2011 at 05:03:43PM +0100, Stanislaw Gruszka wrote:
> You may try debugging patches I posted a while ago:
> http://marc.info/?l=linux-mm&m=131914560820378&w=2
> http://marc.info/?l=linux-mm&m=131914560820293&w=2
> http://marc.info/?l=linux-mm&m=131914560820317&w=2
> 
> With a bit of luck, kernel should panic and dump call-trace when
> bad code start to write at memory addresses where is not suppose
> to.

Thanks for your suggestions. I did as you told me, applied those 3 patches on
top of 3.1 + net-next (the one from 29 Oct 2011), enabled all those things in
config and passed corrupt_dbg=1 on cmdline, but the problem happens without
anything being written to dmesg.

Am I just lacking a bit of luck, or could it mean something (like that the
error is in hardware, the microcode, or something like that)?

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
