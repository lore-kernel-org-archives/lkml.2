Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0HSVcd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:32:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47203 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0HSVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:32:31 -0400
Date: Thu, 19 Aug 2010 23:32:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Rudolf Marek <r.marek@assembler.cz>,
        Huaxu Wan <huaxu.wan@intel.com>, Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Remove warnings of unused
 variables
Message-ID: <20100819233219.31cf694f@hyperion.delvare>
In-Reply-To: <4C6DA1EB.40600@zytor.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
	<1282172027-640-2-git-send-email-fenghua.yu@intel.com>
	<20100819092423.00f76256@hyperion.delvare>
	<4C6D8026.2060800@zytor.com>
	<20100819232655.4223e61f@hyperion.delvare>
	<4C6DA1EB.40600@zytor.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 14:28:11 -0700, H. Peter Anvin wrote:
> On 08/19/2010 02:26 PM, Jean Delvare wrote:
> > 
> > MAINTAINERS is correct. I do not have the time, nor the will, to be the
> > single official maintainer of the hwmon subsystem. I would be happy to
> > be a co-maintainer, but nobody stepped in to co-maintain with me.
> > 
> > Meanwhile, I'm doing my best to off-load some of the hwmon work from
> > Andrew, but that doesn't make me THE maintainer of hwmon.
> > 
> 
> OK.  I was simply wondering if Fenghua should push his coretemp tree
> through you rather than direct to Linus.

Well, it would certainly make sense for Fenghua to send the patches to
me (or better, to the lm-sensors list) and/or Andrew. I doubt Linus is
willing to review random driver patches on a regular basis, especially
when they don't fix anything critical.

-- 
Jean Delvare
