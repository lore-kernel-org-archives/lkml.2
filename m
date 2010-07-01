Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab0GAPSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:18:32 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20401 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab0GAPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:18:30 -0400
Subject: Re: [PATCH] OMAP:DSS2:OMAPFB: Fix probe error path
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Afzal Mohammed <lazfamam@gmail.com>
Cc: "Syrjala Ville (Nokia-MS/Helsinki)" <ville.syrjala@nokia.com>,
       "tj@kernel.org" <tj@kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1277991601-16528-2-git-send-email-lazfamam@gmail.com>
References: <1277991601-16528-1-git-send-email-lazfamam@gmail.com>
	 <1277991601-16528-2-git-send-email-lazfamam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Jul 2010 17:57:18 +0300
Message-ID: <1277996239.2474.354.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2010 14:57:27.0143 (UTC) FILETIME=[B898B770:01CB192D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 15:40 +0200, ext Afzal Mohammed wrote:
> Move sysfs entry creation to omapfb_probe() from omapfb_create_framebuffers().
> This will make sure that sysfs entry is not left behind in case of unsuccessful
> probe due to failure in enabling fb0 of omapfb_create_framebuffers().

Yes, I think this version is ok. Thanks!

 Tomi


