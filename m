Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0JNA1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:27:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0JNA1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:27:50 -0400
Message-ID: <4CB64E69.3050002@zytor.com>
Date: Wed, 13 Oct 2010 17:27:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4F11F.4090104@goop.org> <4CB54640.4000003@kernel.org> <4CB5DEE8.2020400@goop.org> <4CB5F86C.9030900@zytor.com> <4CB6107F.4080908@goop.org> <4CB62D54.7000400@kernel.org> <4CB63D63.5040500@goop.org> <4CB63E57.2000300@zytor.com> <4CB641F7.9040103@goop.org> <3149FE7E-AE5A-496D-8D54-03224C105015@kernel.org> <4CB64DC4.6070303@goop.org>
In-Reply-To: <4CB64DC4.6070303@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2010 05:24 PM, Jeremy Fitzhardinge wrote:
>>>
>> I like this one, can you check if only this one is needed ?
> 
> It is sufficient, but I'd prefer to have both.  I don't think limiting
> the pagetable allocation to mapped memory is necessarily correct, and
> there's no harm in making the Xen code more robust (plus it cleans up a
> couple of #ifdefs).
> 

Yes, I fully agree.  I have put both patches in my tree and will push
them out shortly.

	-hpa

