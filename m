Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1CRABt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:01:49 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:59717 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1CRABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:01:46 -0400
Message-ID: <4D82A068.7020101@snapgear.com>
Date: Fri, 18 Mar 2011 09:59:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: merge of m68knommu and m68k arch branches?
References: <4D5DB83D.80205@snapgear.com>	<AANLkTin0X-ST=rZqwfCA0i5VGCh5ygYXyZFdndiDgR_2@mail.gmail.com>	<AANLkTim=kQOMyKqOEkw5iQjpGhDf0YGMe1ZTnJZkKfr7@mail.gmail.com>	<4D5EEEBB.7050708@snapgear.com>	<AANLkTimmfUJASL47Cs80FJ2mkx3PPvAX57x43nF09tns@mail.gmail.com>	<4D61A986.3060308@snapgear.com> <AANLkTimtr0JbmM2PNtGRyAKE7kNr_FXd==ZC3bM82xsG@mail.gmail.com>
In-Reply-To: <AANLkTimtr0JbmM2PNtGRyAKE7kNr_FXd==ZC3bM82xsG@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Geert,

Looks like we both have our changes for m68k and m68knommu in Linus'
git tree for this merge window. Do you plan to push anything else?

If you are done I will prepare a single git commit on the m68knommu
git tree that merges the m68knommu and m68k arch branches. I will
post here again for one last check over early next week, and if
everyone is happy I will ask Linus to pull it later next week.

How does that sound?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
