Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1BOLvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:51:05 -0500
Received: from smtp.nokia.com ([147.243.128.26]:31636 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1BOLvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:51:01 -0500
Message-ID: <4D5A6851.20702@maxwell.research.nokia.com>
Date: Tue, 15 Feb 2011 13:49:37 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 SeaMonkey/2.0.11
MIME-Version: 1.0
To: balbi@ti.com
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
References: <1297068547-10635-1-git-send-email-weber@corscience.de> <4D5A6353.7040907@maxwell.research.nokia.com> <20110215113717.GN2570@legolas.emea.dhcp.ti.com> <4D5A672A.7040000@samsung.com> <20110215114710.GP2570@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110215114710.GP2570@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> hi,
> 
> On Tue, Feb 15, 2011 at 12:44:42PM +0100, Sylwester Nawrocki wrote:
>>> Are we using the same tree ? I don't see anything related to TASK_* on
>>
>> Please have a look at definition of macro wake_up. This where those
>> TASK_* flags are used.
> 
> $ git grep -e TASK_ drivers/media/video/omap*.[ch]
> $ 
> 
> ???
> 

It's wake_up() on line 414.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
