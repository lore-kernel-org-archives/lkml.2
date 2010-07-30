Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0G3KEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:04:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:34811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab0G3KEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:04:11 -0400
Message-ID: <4C52A3C7.6050901@kernel.org>
Date: Fri, 30 Jul 2010 14:04:55 +0400
From: Denis Kirjanov <dkirjanov@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Denis Kirjanov <dkirjanov@kernel.org>, gregkh@suse.de, davem@davemloft.net,
        liodot@gmail.com, charrer@alacritech.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: Staging: slicoss: Remove net_device_stats from the driver's private
References: <20100710204510.GA18748@hera.kernel.org> <20100722180641.GA9293@kroah.com>
In-Reply-To: <20100722180641.GA9293@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 10:03:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 10:06 PM, Greg KH wrote:
> On Sat, Jul 10, 2010 at 08:45:10PM +0000, Denis Kirjanov wrote:
>> Remove net_device_stats from the driver's private.
> 
> This patch breaks the build, did you even try it?
> I can't apply it, sorry.
> 
> greg k-h
> 

Yes, I have tried it, but, unfortunately, picked up the wrong one :(
I'll fix it up today.

Thanks.

