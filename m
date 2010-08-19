Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0HSV1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:27:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34278 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab0HSV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:27:23 -0400
Date: Thu, 19 Aug 2010 23:26:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Rudolf Marek <r.marek@assembler.cz>,
        Huaxu Wan <huaxu.wan@intel.com>, Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Remove warnings of unused
 variables
Message-ID: <20100819232655.4223e61f@hyperion.delvare>
In-Reply-To: <4C6D8026.2060800@zytor.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
	<1282172027-640-2-git-send-email-fenghua.yu@intel.com>
	<20100819092423.00f76256@hyperion.delvare>
	<4C6D8026.2060800@zytor.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 12:04:06 -0700, H. Peter Anvin wrote:
> On 08/19/2010 12:24 AM, Jean Delvare wrote:
> > 
> > Thanks for the fix, but it is already in my tree:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-coretemp-fix-warning.patch
> > 
> > I'll send it to Linus as part as my next batch of hwmon fixes for
> > 2.6.36.
> 
> Hi Jean,
> 
> Are you overall hwmon maintainer now?  That job is currently listed as
> Orphan in the MAINTAINERS file.

MAINTAINERS is correct. I do not have the time, nor the will, to be the
single official maintainer of the hwmon subsystem. I would be happy to
be a co-maintainer, but nobody stepped in to co-maintain with me.

Meanwhile, I'm doing my best to off-load some of the hwmon work from
Andrew, but that doesn't make me THE maintainer of hwmon.

-- 
Jean Delvare
