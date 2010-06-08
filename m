Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab0FHTGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 15:06:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40584 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab0FHTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 15:06:21 -0400
Message-ID: <4C0E949D.6090002@zytor.com>
Date: Tue, 08 Jun 2010 12:06:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, gregkh@suse.de
Subject: Re: Windows side agrees that lowmem corruption is a problem too
References: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
In-Reply-To: <SNT125-W34B02C6BF1C272DC47AF7DC3D60@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 11:28 AM, Yuhong Bao wrote:
> 
> Adding mingo and gregkh to CC list.
>> Remember the lowmem corruption problems that lead the code that displays this to be added to Linux:> AMI BIOS detected: BIOS may corrupt low RAM, working around it.> which was IMO way too broad. Good news, the Windows side agree that this is a problem too:> http://www.microsoft.com/whdc/system/platform/firmware/mem-corrupt.mspx>> Yuhong Bao
> 

Hardly "way too broad".  I'm starting to think we should enable it
unconditionally, given the number of machines which have exhibited that
problem.  As shown in the whitepaper, Vista/Win7 even avoid using
< 1 MB for a lot of things, presumably for this reason.

If it only was suspend, it would be one thing, but from what I've seen
it has been known to happen at other times too (e.g. HDMI cable insertion!)

	-hpa
