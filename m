Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760402Ab0JGOt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 10:49:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42842 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab0JGOt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 10:49:57 -0400
Message-ID: <4CADDD9F.3030806@zytor.com>
Date: Thu, 07 Oct 2010 07:47:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: mingo@elte.hu, Hans.Rosenfeld@amd.com, robert.richter@amd.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Andreas.Herrmann3@amd.com, peterz@infradead.org, fweisbec@gmail.com,
        rostedt@goodmis.org, acme@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com
Subject: Re: [RFC 0/3] Basic support for LWP
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>	<alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>	<20101005145155.GD173@escobedo.osrc.amd.com>	<alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>	<20101005182739.GE173@escobedo.osrc.amd.com>	<20101005190501.GA21916@elte.hu>	<20101006073558.GJ13563@erda.amd.com>	<AANLkTi=T0QmcKeZcgcR+GKk-9OwQUB_x8XdHiNuU7tE_@mail.gmail.com>	<AANLkTimwVuosF24_gBOTpMydfcj-SQPFyZM4uu=vEPbL@mail.gmail.com>	<4CADD257.7080203@zytor.com>	<AANLkTin+PXzz4qJHX6kHiQW8Rqdrv=hrvq4iWuaOnGiV@mail.gmail.com>	<4CADD73B.8070809@zytor.com> <AANLkTi=nTUvcmk1XBHx=Dp6Qqiksq=m_RDn96y1J+Mck@mail.gmail.com>
In-Reply-To: <AANLkTi=nTUvcmk1XBHx=Dp6Qqiksq=m_RDn96y1J+Mck@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 07:25 AM, Stephane Eranian wrote:
>>
>> No, but you wouldn't be able to use lazy FPU.
>>
> You mean lazy restore, I am guessing here.
> Is that to say, you cannot figure out whether the FPU state in
> the CPU on ctxsw in is yours anymore?
> 

Lazy save/restore, and more or less, yes.  Really, XSAVE was designed to
be saved/restored as a unit, with unused state skipped.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

