Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab1F1PvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:51:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:55769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab1F1Ptd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,437,1304319600"; 
   d="scan'208";a="19795109"
Message-ID: <4E09F853.2000103@intel.com>
Date: Tue, 28 Jun 2011 08:50:43 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at net/core/skbuff.c:127!
References: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan>	<D38E8E86660E514AB505863C19C9287C03A525@ORSMSX101.amr.corp.intel.com>	<alpine.DEB.2.02.1106271814200.6721@p34.internal.lan>	<D38E8E86660E514AB505863C19C9287C03A585@ORSMSX101.amr.corp.intel.com>	<alpine.DEB.2.02.1106271831060.6721@p34.internal.lan> <alpine.DEB.2.02.1106272006310.6864@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1106272006310.6864@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2011 05:08 PM, Justin Piszcz wrote:
> Hi,
>
> Here's another crash: (see the dmesg, its right when powering the disks up)
> http://home.comcast.net/~jpiszcz/20110627/IMG_2704.JPG
>
> In this case, I was mkfs.xfs -f (some disks attached to a sata dock) over
> an Sil 3132 card, I disconnected the card and re-ran it w/ the on-board
> SATA controller and the problem no longer occurred (crashed repeatedly
> everytime with the NIC error), strange.
>
> In any case, will let you know if there are any further crashes after
> removing that PCI-e card.
>
> Justin.
Justin,

One other thing you might try is downloading and installing our latest 
igb driver from e1000.sf.net.  It looks like you are currently using the 
in-kernel driver and it is possible that there may be differences 
between the two that could resolve the issue you are experiencing.

If you are able to reproduce the issue with the Sourceforge driver then 
that will provide valuable information.  Once we have reproduced the 
issue with the Sourceforge driver, we would be able to provide you a 
debug driver so that we can narrow down this issue further.

Thanks,

Alex
