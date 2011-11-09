Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1KIQFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:05:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:33352 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1KIQFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:05:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,484,1315206000"; 
   d="scan'208";a="82968003"
Subject: Re: iwlagn: memory corruption with WPA enterprise
From: wwguy <wey-yi.w.guy@intel.com>
To: =?UTF-8?Q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111109155411.GA1669@nomi.cz>
References: <20111029171554.GA16596@nomi.cz>
	 <20111031160342.GB2225@redhat.com>  <20111109155411.GA1669@nomi.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 07:59:31 -0800
Message-ID: <1320854371.13578.26.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 07:54 -0800, Tomáš Janoušek wrote:
> Hello Stanislaw,
> 
> On Mon, Oct 31, 2011 at 05:03:43PM +0100, Stanislaw Gruszka wrote:
> > You may try debugging patches I posted a while ago:
> > http://marc.info/?l=linux-mm&m=131914560820378&w=2
> > http://marc.info/?l=linux-mm&m=131914560820293&w=2
> > http://marc.info/?l=linux-mm&m=131914560820317&w=2
> > 
> > With a bit of luck, kernel should panic and dump call-trace when
> > bad code start to write at memory addresses where is not suppose
> > to.
> 
> Thanks for your suggestions. I did as you told me, applied those 3 patches on
> top of 3.1 + net-next (the one from 29 Oct 2011), enabled all those things in
> config and passed corrupt_dbg=1 on cmdline, but the problem happens without
> anything being written to dmesg.
> 
> Am I just lacking a bit of luck, or could it mean something (like that the
> error is in hardware, the microcode, or something like that)?
> 
I am not sure it is uCode related, is there any chance you can bisect
the problem?

we have a major code re-structure around .38/.39 time and not sure it
cause some un-expected problem. 

at the meantime, we will following your instruction and see if we can
re-produce the problem you are seeing

Thanks
Wey


