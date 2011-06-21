Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1FUAC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:02:59 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41067 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756282Ab1FUAC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:02:57 -0400
Message-ID: <4DFFDF6D.7060008@metafoo.de>
Date: Tue, 21 Jun 2011 02:01:49 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 2/8] regmap: Add I2C bus support
References: <20110620124608.GB31140@opensource.wolfsonmicro.com> <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1308574489-31322-2-git-send-email-broonie@opensource.wolfsonmicro.com> <4DFFD64F.8040902@metafoo.de> <20110620234140.GB1905@opensource.wolfsonmicro.com>
In-Reply-To: <20110620234140.GB1905@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 01:41 AM, Mark Brown wrote:
> On Tue, Jun 21, 2011 at 01:22:55AM +0200, Lars-Peter Clausen wrote:
>> On 06/20/2011 02:54 PM, Mark Brown wrote:
>>> [...]
>>> +
>>> +#include <linux/regmap.h>
>>> +#include <linux/i2c.h>
> 
>> #include <linux/init.h>
> 
> For...?
> 

postcore_initcall and module_exit
