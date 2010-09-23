Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab0IWNkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:40:46 -0400
Received: from wh01.wirehydrant.com ([74.207.240.231]:48205 "EHLO
	wh01.wirehydrant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0IWNkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:40:45 -0400
Message-ID: <4C9B58DB.8020202@innovacomputing.com>
Date: Thu, 23 Sep 2010 08:40:43 -0500
From: Alex Adriaanse <alex@innovacomputing.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steve Thompson <smt@vgersoft.com>
CC: linux-kernel@vger.kernel.org, drbd-user@lists.linbit.com
Subject: Re: [DRBD-user] Hanging kernel
References: <4C9AA4EB.70407@innovacomputing.com> <alpine.LRH.0.9999.1009230842330.5001@helios.vgersoft.com>
In-Reply-To: <alpine.LRH.0.9999.1009230842330.5001@helios.vgersoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/23/2010 7:46 AM, Steve Thompson wrote:
> What are your values of:
>
>     sysctl vm.dirty_ratio
>     sysctl vm.dirty_background_ratio
20 and 10, respectively.

Thanks, I'll keep tuning these settings in mind.

Alex
