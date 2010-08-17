Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0HQHWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:22:20 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:58284 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0HQHWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:22:19 -0400
Message-ID: <4C6A38A4.6070505@neli.hopto.org>
Date: Tue, 17 Aug 2010 09:22:12 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 7/9] RapidIO: Add handling for PW message from a lost
 device
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-8-git-send-email-alexandre.bounine@idt.com> <4C692F31.2020705@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6040@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6040@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> That "real" PW message may be dropped by the controller (85xx is good
> example). Everything depends on number of PW messages directed to the
> host/controller. I am trying to use the first available notification to
> service device removal. If the "real" PW message is received it should
> be processed without any further action. 

Perhaps an idea is to use the repeated port-write sending feature so 
that dropped port-writes are not a problem anymore.

Micha
