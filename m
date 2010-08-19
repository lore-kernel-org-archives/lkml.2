Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab0HSTF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:05:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33967 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab0HSTF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:05:26 -0400
Message-ID: <4C6D8026.2060800@zytor.com>
Date: Thu, 19 Aug 2010 12:04:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Rudolf Marek <r.marek@assembler.cz>,
        Huaxu Wan <huaxu.wan@intel.com>, Chen Gong <gong.chen@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Remove warnings of unused variables
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>	<1282172027-640-2-git-send-email-fenghua.yu@intel.com> <20100819092423.00f76256@hyperion.delvare>
In-Reply-To: <20100819092423.00f76256@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 12:24 AM, Jean Delvare wrote:
> 
> Thanks for the fix, but it is already in my tree:
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-coretemp-fix-warning.patch
> 
> I'll send it to Linus as part as my next batch of hwmon fixes for
> 2.6.36.
> 

Hi Jean,

Are you overall hwmon maintainer now?  That job is currently listed as
Orphan in the MAINTAINERS file.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

