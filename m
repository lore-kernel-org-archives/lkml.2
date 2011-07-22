Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1GVPow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:44:52 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52985 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754286Ab1GVPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:44:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AO01OV+AScDJXe2K7dKXoy4gDyFGu7Aen8WR9zB1QS/3V5i0fXBV9f1Sbt62BX0C6IEXQPD7tTCDgsLb6EtHMw3Ue7QONQrpX33sQ1Cn4RLdR4USvdB3J+Usz25X7gyA;
Date: Fri, 22 Jul 2011 08:44:45 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: <Narendra_K@Dell.com>
Cc: <kernel@linuxace.com>, <linux-kernel@vger.kernel.org>,
        <Jordan_Hargrave@Dell.com>, <Shyam_Iyer@Dell.com>,
        <Charles_Rose@Dell.com>
Subject: Re: [PATCH] Fix embedded nic order on Dell PowerEdge systems
Message-ID: <20110722084445.68800e2c@jbarnes-desktop>
In-Reply-To: <E31FB011129F30488D5861F3839049151E9056C57A@BLRX7MCDC201.AMER.DELL.COM>
References: <1307564053-2996-1-git-send-email-kernel@linuxace.com>
	<E31FB011129F30488D5861F3839049151DA349A086@BLRX7MCDC201.AMER.DELL.COM>
	<20110710033243.GA12541@linuxace.com>
	<E31FB011129F30488D5861F3839049151E9056C57A@BLRX7MCDC201.AMER.DELL.COM>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 17:52:01 +0530
<Narendra_K@Dell.com> wrote:
> > This patch is still not included in 3.0.0-rc6, nor in any stable series.
> > Some reason for this?  And did Dell do any testing at all on existing hardware
> > before submitting 6e8af08dfa4?  Seems even a minor amount of testing
> > should have shown this regression.
> > 
> > Given 3.0.0 is expected soon, perhaps this can be included?  Jesse?
> > 
> 
> Hi, I think for the patch to be included into stable, it needs to be in the mainline.
> Hi Jesse, please consider queuing this patch  for mainline.

Ouch, I was sure I had this queued a long time ago but somehow it got
dropped.  Anyway it's queued now and will appear in 3.1.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
