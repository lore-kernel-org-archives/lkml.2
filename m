Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab2EIJAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:00:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:39869 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758809Ab2EIJAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:00:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98015272"
Date: Wed, 9 May 2012 12:01:58 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Add and use vsprintf extension %pMbt for bluetooth
 macs
Message-ID: <20120509090156.GB8473@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Joe Perches <joe@perches.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Gustavo F. Padovan" <padovan@profusion.mobi>,
	linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <cover.1291419007.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1291419007.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

On Fri, Dec 03, 2010 at 06:33:02PM -0800, Joe Perches wrote:
> Using vsprintf extensions can save text and data.
> Add %pMbt for the byte reversed output for bluetooth addresses.
> 
> Joe Perches (2):
>   vsprintf: Add %pMbt, bluetooth mac address
>   bluetooth: Use printf extension %pMbt

I think this would be the best way to solve our issues with batostr.

BTW: What is the status with this patch series? I saw that it was acked by
Gustavo but not applied for some reason.

Best regards 
Andrei Emeltchenko 

