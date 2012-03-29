Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab2C2EoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:44:20 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59640 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517Ab2C2EoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:44:13 -0400
Message-ID: <4F73E895.6000207@ti.com>
Date: Thu, 29 Mar 2012 10:14:05 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Michael Bohan <mbohan@codeaurora.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, lrg@ti.com,
        LKML <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
References: <4F6BCF47.4090200@codeaurora.org> <20120326130005.GQ3098@opensource.wolfsonmicro.com> <4F726B96.8070508@codeaurora.org> <20120328100957.GD3232@opensource.wolfsonmicro.com> <4F736451.8020900@codeaurora.org> <20120328193341.GD3232@opensource.wolfsonmicro.com> <4F73A798.6030607@codeaurora.org>
In-Reply-To: <4F73A798.6030607@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2012 05:36 AM, Michael Bohan wrote:
> Put simply, whose responsibility is it to assign the
> regulator_desc->supply_name pointer before registering a regulator
> device added from Device Tree?

The drivers, and its expected to know, and not lookup something from the 
DT node to figure out what regulator_desc->supply_name should be.

You can read through the discussion when the bindings were being
proposed.
http://www.spinics.net/lists/linux-omap/msg58395.html
