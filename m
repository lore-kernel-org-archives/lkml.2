Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab0HLOPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:15:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55453 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974Ab0HLOPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:15:47 -0400
Message-ID: <4C6401FD.1050600@zytor.com>
Date: Thu, 12 Aug 2010 07:15:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Ma, Ling" <ling.ma@intel.com>
CC: Namhyung Kim <namhyung@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH V2] [X86] Fix potential issue on memmove
References: <1281595715.1631.5.camel@leonhard> <C10D3FB0CD45994C8A51FEC1227CE22F0E483AD918@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <C10D3FB0CD45994C8A51FEC1227CE22F0E483AD918@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 11:52 PM, Ma, Ling wrote:
> Thanks, I will fix it in next version.

Also, please split this into two patches -- one for fixing memmove, and
the other for re-enabling the alias avoidance in memcpy.
	
	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

