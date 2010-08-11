Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0HKSte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:49:34 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:37936 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab0HKStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:49:33 -0400
Date: Wed, 11 Aug 2010 21:49:22 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: "Balbi Felipe (Nokia-MS/Helsinki)" <felipe.balbi@nokia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and
 TORPEDO development kits
Message-ID: <20100811184922.GB21778@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20100811172232.GA21391@nokia.com>
 <77A0A4DB5BF2A44283E5522C27234AC6021C82B4@EDPRSRV011.logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <77A0A4DB5BF2A44283E5522C27234AC6021C82B4@EDPRSRV011.logicpd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 11, 2010 at 08:45:22PM +0200, ext Jacob Tanenbaum wrote:
>No one else uses the ifdef but we were told from an earlier submission
>we should because if both boards are disabled in the .config it would
>inform the user on bootup

What do you mean ? If these boards are't enabled on .config then this 
board-file won't even get added to the binary so those machine ids won't 
be available, right ?

-- 
balbi

DefectiveByDesign.org
