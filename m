Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab1ELV3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:29:20 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:22155 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758730Ab1ELV3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:29:18 -0400
Message-ID: <4DCC512E.1000603@bluewatersys.com>
Date: Fri, 13 May 2011 09:29:18 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        mchehab@redhat.com, linux-kernel@vger.kernel.org,
        Josh Wu <josh.wu@atmel.com>, lars.haring@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
 support
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>	<20110512114530.GE18952@game.jcrosoft.org> <Pine.LNX.4.64.1105121413220.24486@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105121413220.24486@axis700.grange>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 12:14 AM, Guennadi Liakhovetski wrote:
> On Thu, 12 May 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> [snip]
> 
>>> +	if (0 == *nbuffers)
>> please invert the test
> 
> Don't think this is required by CodingStyle or anything like that. If it 
> were, you'd have to revamp half of the kernel.

It should at least be consistent within a file, which it is not true in
this case. I think the preferred style is to have the variable on the left.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
