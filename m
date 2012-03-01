Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab2CAHoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:44:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:16949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab2CAHoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:44:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131489397"
Date: Thu, 1 Mar 2012 09:43:56 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Silence static checker warning.
Message-ID: <20120301074354.GA25627@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	santosh prasad nayak <santoshprasadnayak@gmail.com>,
	marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1330535217-26785-1-git-send-email-santoshprasadnayak@gmail.com>
 <CAMXE1-oXtheVHDuU3w52mXqmuY8AK4kk+tuvJpVRDq2=+qEnsQ@mail.gmail.com>
 <CAOD=uF5Ux0w=EPbX0V3qOy1VnZQr6Q35uUxrF9Qv1hZ4MjYJOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOD=uF5Ux0w=EPbX0V3qOy1VnZQr6Q35uUxrF9Qv1hZ4MjYJOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Thu, Mar 01, 2012 at 11:07:14AM +0530, santosh prasad nayak wrote:
> @Dan,
>            In future patches I will take care of it. Is it ok ? If
> required I can resend the patch with required changes on subject line.
> 
> @Andrei
> 
> In my local clone your changes are  not visible.
> 
> What is the schedule of linux-next ?
> Is it updated every week or bi-weekly or monthly ?

We use Johan's tree so far:
git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth-next.git

I think the tree we use shall be published on bluez.org website.

The change seems to be included to:
"pull request: bluetooth-next 2012-02-24"

http://www.spinics.net/lists/linux-wireless/msg85442.html

Best regards 
Andrei Emeltchenko 


