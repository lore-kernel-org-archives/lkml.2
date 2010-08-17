Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0HQHbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:31:37 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:38146 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0HQHbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:31:36 -0400
Message-ID: <4C6A3AD0.5090005@neli.hopto.org>
Date: Tue, 17 Aug 2010 09:31:28 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Thomas Moll <thomas.moll@sysgo.com>
Subject: Re: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <4C692F7E.1060208@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6061@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6061@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> Micha Nelissen wrote:
>> This is not 'Gen2' specific, as these error management extensions also
>> exist in v1.2/1.3 (?) of the specification? E.g. tsi56x and tsi57x
> could
>> support this functionality?
> 
> Correct. EM extensions exist since v1.3. But implementation before Gen2
> switches relied
> on proprietary device specific mechanism (tsi57x). Addition of Gen2

Do you mean the tsi56x here?

Can you explain what the difference what you mean with relied on 
proprietary vs standard? E.g. setting the port-write destination ID 
register is standardized? And the format of the port-write message 
itself is also.

Micha
