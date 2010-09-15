Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0IOTIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:08:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43298 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab0IOTIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:08:53 -0400
Message-ID: <4C9119B1.7020808@zytor.com>
Date: Wed, 15 Sep 2010 12:08:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: ling.ma@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] [X86] Fix potential issue on memmove
References: <1284515426-7417-1-git-send-email-ling.ma@intel.com>
In-Reply-To: <1284515426-7417-1-git-send-email-ling.ma@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 06:50 PM, ling.ma@intel.com wrote:
> From: Ma Ling <ling.ma@intel.com>
> 
> memmove allow source and destination address to be overlap, 
> but no limitation for memcpy. So memmove use forward or
> backward copy mode to handle src > dest and dest > src cases respectively.
> However memcpy has not address overlap, it may use any copy mode
> theoretically. Our original memmove will call memcpy and assume
> it must use forward copy mode, otherwise the system will crash,
> it is potential issue. The patch based on tip/x86/mem avoids
> this assumption.
> 
> Signed-off-by: Ma Ling <ling.ma@intel.com>

This patch is certainly not based on the current tip:x86/mem.  Could you
check out the current tip:x86/mem (which has a previous patch of yours
in it) and submit an incremental patch with a description about what
updates the previous patch and why?

	-hpa
