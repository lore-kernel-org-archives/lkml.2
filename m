Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab0GGXMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:12:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46078 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756942Ab0GGXMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:12:37 -0400
Message-ID: <4C3509C7.40203@zytor.com>
Date: Wed, 07 Jul 2010 16:12:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: feng.tang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@elte.hu, jacob.jun.pan@intel.com, randy.dunlap@oracle.com
Subject: Re: [PATCH v2 0/5] patches to settle i8042 with Intel MID platforms
References: <1278342202-10973-1-git-send-email-feng.tang@intel.com> <4C32364D.2040705@zytor.com> <20100705202221.GA16978@core.coreip.homeip.net>
In-Reply-To: <20100705202221.GA16978@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 01:22 PM, Dmitry Torokhov wrote:
> 
> Looks hood to me as well. We can either merge it through my tree or x86
> tree, I don't have a preference.
> 

OK, I found that this series breaks allmodconfig, because i8042 can be a
module.  The obvious solution is to export x86_platform to modules, I
presume that is okay with everyone (especially tglx)?  If so I'll push
this tree out tomorrow morning.

	-hpa
