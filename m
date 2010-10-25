Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0JYNLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:11:53 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42151 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0JYNLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:11:52 -0400
Subject: Re: [PATCH] wireless/wl1271: remove redundant if-statement
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <4CC4B210.2010608@lwfinger.net>
References: <20101025000744.17f7086e@absol.kitzblitz>
	 <4CC4B210.2010608@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 16:10:45 +0300
Message-ID: <1288012245.21130.24.camel@chilepepper>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 13:10:49.0546 (UTC) FILETIME=[0B3FE2A0:01CB7446]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 00:24 +0200, ext Larry Finger wrote:
> On 10/24/2010 05:07 PM, Nicolas Kaiser wrote:
> > Apparently the return value of wl1271_ps_elp_sleep never gets
> > checked anyway.
> 
> The patch is fine, but this comment is a little misleading as
> wl1271_ps_elp_sleep() is void and cannot return a value.

Yes, this patch is good, but please rewrite the description, as Larry
suggested.

-- 
Cheers,
Luca.

