Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab0JZUhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:37:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759497Ab0JZUht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:37:49 -0400
Message-ID: <4CC73C07.3030704@zytor.com>
Date: Tue, 26 Oct 2010 13:37:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kvm@vger.kernel.org, avi@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
References: <20101026123828.GA30434@basil.fritz.box> <4CC70333.80400@zytor.com> <20101026163748.GB29961@basil.fritz.box> <4CC705ED.1020105@zytor.com> <20101026170142.GD29961@basil.fritz.box> <4CC71B94.2010802@zytor.com> <20101026202734.GB2603@basil.fritz.box>
In-Reply-To: <20101026202734.GB2603@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 01:27 PM, Andi Kleen wrote:
>> That is an issue too, as 3.x does a lot fewer optimizations than 4.x.
> 
> Well to be fair the default -Os build disables most of the fancy stuff
> (and the resulting code is often terrible) 
> 
> I guess it doesn't matter too much, at least not with the 
> CONFIG_CC_OPTIMIZE_SIZE default.
> 

Yes, it would be nice to have a setting which is "optimize but don't
bloat excessively."

	-hpa
