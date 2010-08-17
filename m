Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0HQHMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:12:43 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:55986 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0HQHMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:12:41 -0400
Message-ID: <4C6A3665.7030207@neli.hopto.org>
Date: Tue, 17 Aug 2010 09:12:37 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/9] RapidIO,  powerpc/85xx: modify RIO port-write interrupt
 handler
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-3-git-send-email-alexandre.bounine@idt.com> <4C692B42.9050407@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F94@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F94@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
> capable to receive and keep only one PW message. Therefore, I copy it
> into the driver's FIFO and re-enable HW Rx queue (it is called queue but
> can accept only one entry) ASAP. I have a test setup that is capable
> generate multiple PW messages and see many messages discarded by PW
> controller because of this single-entry HW queue.

Primarily due to the single entry queue, the order of checking is 
probably insignificant? :-) Anyway, I don't mind changing the order.

Micha
