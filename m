Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab1FPOVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:21:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab1FPOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FCMw+FY1YSGHv0ZM+PZ0ssP3hyH2woaKQYobD8edDoXSjtIfTbszdNLYmBARAhuGaR
         HGMpE+DckLH7NJuZYerOA6LK7N9bWuIjC6mdLlMXYEM4o9O5kDsjNUvNYbsXTIQF+F3l
         qGhkvoKs88YwO3ohM+o3S7l6VGbCTeFIQ+TGE=
Message-ID: <4DFA1160.5020208@gmail.com>
Date: Thu, 16 Jun 2011 09:21:20 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 03/11] dt/irq: add irq_domain_add_simple() helper
References: <20110616042653.29371.2052.stgit@ponder> <20110616044141.29371.76366.stgit@ponder> <4DFA0D83.6070604@gmail.com>
In-Reply-To: <4DFA0D83.6070604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot one thing.

On 06/16/2011 09:04 AM, Rob Herring wrote:
> Grant,
> 
> On 06/15/2011 11:41 PM, Grant Likely wrote:
>> irq_domain_add_simple() is an easy way to generate an irq translation
>> domain for simple irq controllers.  It assumes a flat 1:1 mapping from
>> hardware irq number to an offset of the first linux irq number assigned
>> to the controller
>>

The description and headline are a bit out of date since adding
irq_domain_generate_simple.

Rob
