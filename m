Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab0J1OeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:34:02 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:52738 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab0J1OeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:34:01 -0400
Message-ID: <4CC98A3C.5010903@ladisch.de>
Date: Thu, 28 Oct 2010 16:35:40 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Matthias Dunda <user254@t1817.greatnet.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Reading temperature from another Kernel modules
References: <007FBA04-E52D-497B-A43B-738F15E33558@t1817.greatnet.de>
In-Reply-To: <007FBA04-E52D-497B-A43B-738F15E33558@t1817.greatnet.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Dunda wrote:
> BUT: how do I get the temp? Most of the internal functions require a
> struct device or a struct i2c_client, which - I assume - are perfectly
> provided by the kernel when going the way over the proc file system.
> 
> I tried to statically save such a struct during the probing process
> (this is the above my_local_client), but this works neither. When I
> use the saved struct to call jc42_read_value, I always get a
> temperature value which is not correct at all.

Is that saved pointer actually the same?  (Put printk()s in both your
function and some sysfs-called function.)


Regards,
Clemens
