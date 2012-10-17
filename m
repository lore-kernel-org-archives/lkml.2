Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2JQBip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 21:38:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:63265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab2JQBio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 21:38:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,597,1344236400"; 
   d="scan'208";a="206907212"
Message-ID: <507E0C1A.1010705@intel.com>
Date: Wed, 17 Oct 2012 09:38:34 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>, Shane Huang <shane.huang@amd.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ata4.00: failed to get Identify Device Data, Emask 0x1
References: <20121016144932.GA24044@aftab.osrc.amd.com> <20121016155824.00d5b618@pyramind.ukuu.org.uk> <20121016151830.GB24044@aftab.osrc.amd.com>
In-Reply-To: <20121016151830.GB24044@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 11:18 PM, Borislav Petkov wrote:
> On Tue, Oct 16, 2012 at 03:58:24PM +0100, Alan Cox wrote:
>> Can you check whether 3.6 works on them. I know 3.6 is horribly broken
>> on several brands of AHCI controller (Jmicron for example). Dunno
>> where Jeff is on fixing the regressions ?
> 
> If by "works" you mean I don't see the message there, then yes, it does.
> Logs say the message started appearing on Oct 4th after me building
> Linus master after the merge window started.
> 
> Ok, let me test 3.6.2 just in case ...<tests>... yes, no error message
> there.

This is brought by commit: 65fe1f0f66a57380229a4ced844188103135f37b,
ahci: implement aggressive SATA device sleep support.

Shane, got time to take a look? This debug message made people
uncomfortable :-)

Thanks,
Aaron

