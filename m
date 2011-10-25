Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1JYPKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:10:09 -0400
Received: from mail.fuel7.com ([74.222.0.51]:35088 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab1JYPKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:10:07 -0400
Message-ID: <4EA6D14D.6060800@fuel7.com>
Date: Tue, 25 Oct 2011 10:10:05 -0500
From: Kyle Manna <kyle.manna@fuel7.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 1/6] mfd: TPS65910: Handle non-existent devices
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com> <1319475964-10841-2-git-send-email-kyle.manna@fuel7.com> <20111025071417.GE2919@opensource.wolfsonmicro.com>
In-Reply-To: <20111025071417.GE2919@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 02:14 AM, Mark Brown wrote:
> On Mon, Oct 24, 2011 at 12:05:59PM -0500, Kyle Manna wrote:
>> Attempt to read the first register of the device, if there is no
>> device return -ENODEV
> Can you check for a known value in any of the registers?
Unfortunately on this chip there aren't any identification or constant 
test registers.  The only register close is the JTAGVERNUM_REG and 
that's will change across silicon revisions.

- Kyle
