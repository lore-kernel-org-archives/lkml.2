Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967008Ab0GSWFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:05:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:32376 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966846Ab0GSWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:05:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,228,1278313200"; 
   d="scan'208";a="536984218"
Message-ID: <4C44CC2E.405@linux.intel.com>
Date: Mon, 19 Jul 2010 15:05:34 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Patrick Pannuto <ppannuto@codeaurora.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@elte.hu, akinobu.mita@gmail.com,
        sboyd@codeaurora.org
Subject: Re: [PATCH] timer: Added usleep[_range][_interruptible] timer
References: <4C44BB69.8050300@codeaurora.org>
In-Reply-To: <4C44BB69.8050300@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/2010 1:54 PM, Patrick Pannuto wrote:
> *** INTRO ***
>    


I like the general idea, but I kinda doubt the "interruptible" version 
makes sense for this...
do you have any users for that in mind? if not... can we leave the 
interruptible version out... makes it simpler by a lot.

