Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2HPTEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:04:40 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:34244 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2HPTEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:04:37 -0400
Message-ID: <502D4444.9050400@kernel.org>
Date: Thu, 16 Aug 2012 20:04:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        kernel-janitors@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/iio/adc/at91_adc.c: use devm_ functions
References: <1343729383-30073-1-git-send-email-Julia.Lawall@lip6.fr> <5017D148.6030006@metafoo.de> <alpine.DEB.2.02.1207311509040.1894@hadrien> <502AB5F1.3050908@kernel.org> <502B658F.5040100@metafoo.de> <alpine.DEB.2.02.1208151119290.2000@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1208151119290.2000@localhost6.localdomain6>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:20 AM, Julia Lawall wrote:
>> devm_request_and_ioremap will already print a error messages on it's own if
>> something goes wrong. So strictly speaking this one is redundant, but I don't
>> think it is necessary to do a resend just for this, maybe you can remove the
>> extra dev_err when you apply the patch.
> 
> Thanks for pointing that out.  I will get rid of the messages in the future.  That seems easier than figuring out how to
> adapt the message to the new function.
> 
merged with that line removed as suggested.  Thanks Julia and Lars-Peter.
