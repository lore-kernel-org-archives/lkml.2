Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab0JSAro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:47:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:8586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab0JSArn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:47:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,347,1283756400"; 
   d="scan'208";a="565223739"
Date: Mon, 18 Oct 2010 17:47:40 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jacob Pan <jacob.jun.pan@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: USB3.0 ch11 definitions
Message-ID: <20101019004740.GB2574@xanatos>
References: <1287414160-12307-1-git-send-email-tlinder@codeaurora.org>
 <4CBCA452.6070804@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBCA452.6070804@mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 11:47:30PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 18-10-2010 19:02, Tatyana Brokhman wrote:
> 
> >Adding hub SuperSpeed usb definitions as defined by ch10 of the USB3.0
> >spec.
> 
>    So it's chapter 10 or 11? ;-)

The hub definitions are in chapter 11 in the USB 2.0 bus spec, and
chapter 10 in the USB 3.0 bus spec.  But I don't think we're going to
rename ch11.h.

Sarah Sharp
