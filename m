Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1BNUCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:02:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55454 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab1BNUCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:02:31 -0500
Message-ID: <4D598A3A.9080802@zytor.com>
Date: Mon, 14 Feb 2011 12:02:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <4D50343E.1020906@kernel.org>	<alpine.DEB.2.00.1102071839060.7277@kaball-desktop>	<4D504161.2060900@kernel.org>	<4D506A85.9030802@goop.org>	<4D50B4B5.4050505@kernel.org>	<4D519AAA.8070309@zytor.com>	<4D547962.8040403@goop.org>	<4D547B74.1030302@kernel.org>	<4D54844B.4010007@zytor.com>	<4D5488D5.2020607@kernel.org>	<20110214162602.GB11290@dumpdata.com> <AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com>
In-Reply-To: <AANLkTimVMG1N2Ln+zSCWgGPSSv9kdUM844UGD+HfeOtE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 09:55 AM, Yinghai Lu wrote:
> 
> Assume, we can update vmlinux.lds.S to make _end to be 2M aligned as
> Stefano suggested?
> 

I am concerned about this.  This feels like papering over a bug.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

