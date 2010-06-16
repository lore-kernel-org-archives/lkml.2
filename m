Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab0FPPW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 11:22:57 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34163 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab0FPPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 11:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AUrNaESBDaVLEQrvcXkTo4YgMIhgX5Bq3aV83h29jXcnCGe92iwBqqlp81n5liG/IC
         /DPNlr1rwtQiTfcrexrI6S5WpECW9VcUFJAWgmbLGjjjuH6XY3KDSBaxWahmJGrHR3wX
         pw80fErw44URwblcfrkBIVQh+qhPpPbg0PDJs=
Date: Thu, 17 Jun 2010 00:22:47 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 8/9] oom: cleanup has_intersects_mems_allowed()
Message-ID: <20100616152247.GG9278@barrios-desktop>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
 <20100616203445.72EC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616203445.72EC.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 08:35:15PM +0900, KOSAKI Motohiro wrote:
> 
> Now has_intersects_mems_allowed() has own thread iterate logic, but
> it should use while_each_thread().
> 
> It slightly improve the code readability.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
-- 
Kind regards,
Minchan Kim
