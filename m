Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0HDLN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:13:27 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18886 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab0HDLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:13:26 -0400
Date: Wed, 4 Aug 2010 14:11:56 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Section Mismatches
Message-ID: <20100804111156.GD19377@nokia.com>
Reply-To: felipe.balbi@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Aug 2010 11:13:11.0087 (UTC) FILETIME=[063503F0:01CB33C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

I see that your commit 0db252452378aa7a9e001a13226e1cd1dc61453d removed 
the *_driver from the symbol whitelist when referencing init section 
(heh, it took a while), but could you explain what's the rationale 
behind that ?

Thanks a lot

-- 
balbi

DefectiveByDesign.org
