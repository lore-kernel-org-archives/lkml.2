Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab1KVWzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:55:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:1170 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1KVWzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78996668"
Subject: Re: 3.1+ iwlwifi lockup
From: wwguy <wey-yi.w.guy@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111122225409.GA23889@redhat.com>
References: <20111031143408.GA17152@redhat.com>
	 <1321992902.8072.7.camel@wwguy-ubuntu> <20111122204741.GA3764@redhat.com>
	 <1321991916.11647.77.camel@wwguy-huron> <20111122225409.GA23889@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 14:49:20 -0800
Message-ID: <1322002160.8072.9.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 14:54 -0800, Dave Jones wrote:
> On Tue, Nov 22, 2011 at 11:58:36AM -0800, Guy, Wey-Yi wrote:
>  > Hi Dave,
>  > 
>  > Not sure what happens, feel like memory corruption but not sure. the
>  > contain of the command is totally bogus.
>  > 
>  > Could you please test and send update, it is part of "3.2+rc2+
>  > Regressions from 3.0 and 3.1" reports
>  
> Will do.
> 
> Not sure if it's a helpful data point, but the access point is
> an apple airport (in case that's sending something strange that
> confused the firmware).

not sure, but something to keep in-mind for sure.

Thanks for the help.

Wey

>  


