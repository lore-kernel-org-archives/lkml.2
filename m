Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1K2RR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:17:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:39035 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab1K2RRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:17:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,591,1315206000"; 
   d="scan'208";a="80281777"
Date: Tue, 29 Nov 2011 17:29:08 +0000
From: Alan Cox <alan@linux.intel.com>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com, dg77.kim@samsung.com,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Jason.Wortham@maxim-ic.com
Subject: Re: [PATCH 4/4] x86-mrst: Add battery fuel guage platform data
Message-ID: <20111129172908.3cadbc7d@bob.linux.org.uk>
In-Reply-To: <1322509793-10800-5-git-send-email-dirk.brandewie@gmail.com>
References: <1322509793-10800-1-git-send-email-dirk.brandewie@gmail.com>
	<1322509793-10800-5-git-send-email-dirk.brandewie@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Nov 2011 11:49:53 -0800
dirk.brandewie@gmail.com wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Add platform data to configure the MAX17042 at POR.  The accuracy of
> the MAX17042 is improved by initializing the fuel gauge with the
> battery characterization data.Summary:


Please cc the x86 maintainers on the final version of this as there is
stuff queued there from me for updating bits of mrst.c as well.

Alan
