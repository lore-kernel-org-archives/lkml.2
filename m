Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab0D3WS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:18:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39035 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0D3WS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:18:57 -0400
Message-ID: <4BDB573E.6070307@zytor.com>
Date: Fri, 30 Apr 2010 15:18:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org> <alpine.LNX.2.00.1004290040510.9849@pobox.suse.cz> <20100430075510.GA21105@elte.hu> <4BDA8DCA.9010401@kernel.org>
In-Reply-To: <4BDA8DCA.9010401@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 12:59 AM, Tejun Heo wrote:
> Hello,
> 
> On 04/30/2010 09:55 AM, Ingo Molnar wrote:
>> A similar patch was sent a few weeks ago, it was objected to and rejected - 
>> the copyright character was used for legal reasons.
> 
> Paul says that "Copyright" is enough, so what are the legal reasons?
> 
> Also, if the copyright designator absolutely has to be there, then can
> it be in UTF-8 at least?
> 
> Thanks.
> 

Transcoding to UTF-8 would seem appropriate.  On the other hand, I am
most definitely not a lawyer.

	-hpa

