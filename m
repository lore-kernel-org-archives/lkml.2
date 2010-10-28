Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab0J1R2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:28:35 -0400
Received: from mx2.compro.net ([12.186.155.4]:58893 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab0J1R2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:28:30 -0400
X-IronPort-AV: E=Sophos;i="4.58,253,1286164800"; 
   d="scan'208";a="5969919"
Message-ID: <4CC9B2BD.1050504@compro.net>
Date: Thu, 28 Oct 2010 13:28:29 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Dragoslav Zaric <zaricdragoslav@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Tickles scheduler
References: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com> <alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk> <alpine.DEB.2.00.1010271725260.9704@router.home> <AANLkTimOx=cMr+cwzEc8z7puZDEpa_7aDOxCPSzotjBP@mail.gmail.com> <alpine.DEB.2.00.1010280845320.25874@router.home>
In-Reply-To: <alpine.DEB.2.00.1010280845320.25874@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2010 09:47 AM, Christoph Lameter wrote:
> The current plan is to switch off the tick when a process is running that
> cannot be preempted ("realtime" (very bad choice of terms) tasks).
> 

In what kind of time frame is this plan? And in the plan what will be the criteria for
"cannot be preempted"?

Thanks
Mark
