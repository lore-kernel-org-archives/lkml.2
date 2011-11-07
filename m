Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab1KGVeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:34:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45955 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab1KGVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:34:19 -0500
Message-ID: <4EB84EC9.1000104@zytor.com>
Date: Mon, 07 Nov 2011 13:34:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
References: <20111107202324.GA27515@srcf.ucam.org> <4EB8413D.6030500@zytor.com> <20111107203752.GA27875@srcf.ucam.org> <4EB8436B.20603@zytor.com> <20111107204839.GA28261@srcf.ucam.org> <4EB84644.8060102@zytor.com> <20111107205859.GA28681@srcf.ucam.org> <4EB84734.3070006@zytor.com> <20111107210702.GA28781@srcf.ucam.org> <4EB84BAD.6030707@zytor.com> <20111107212328.GA29090@srcf.ucam.org>
In-Reply-To: <20111107212328.GA29090@srcf.ucam.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 01:23 PM, Matthew Garrett wrote:
> 
> I know. But we also have to handle being called after 
> ExitBootServices(). There are going to be people who don't want to deal 
> with signing their kernel builds.
>  

Could you clarify why these two are connected?

	-hpa
