Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0HSV3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:29:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0HSV3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:29:13 -0400
Message-ID: <4C6DA1EB.40600@zytor.com>
Date: Thu, 19 Aug 2010 14:28:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Rudolf Marek <r.marek@assembler.cz>,
        Huaxu Wan <huaxu.wan@intel.com>, Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Remove warnings of unused variables
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>	<1282172027-640-2-git-send-email-fenghua.yu@intel.com>	<20100819092423.00f76256@hyperion.delvare>	<4C6D8026.2060800@zytor.com> <20100819232655.4223e61f@hyperion.delvare>
In-Reply-To: <20100819232655.4223e61f@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 02:26 PM, Jean Delvare wrote:
> 
> MAINTAINERS is correct. I do not have the time, nor the will, to be the
> single official maintainer of the hwmon subsystem. I would be happy to
> be a co-maintainer, but nobody stepped in to co-maintain with me.
> 
> Meanwhile, I'm doing my best to off-load some of the hwmon work from
> Andrew, but that doesn't make me THE maintainer of hwmon.
> 

OK.  I was simply wondering if Fenghua should push his coretemp tree
through you rather than direct to Linus.

	-hpa
