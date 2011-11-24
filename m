Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1KXQ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:58:51 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:57715 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab1KXQ6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:58:17 -0500
Message-ID: <4ECE8565.8060708@newsguy.com>
Date: Thu, 24 Nov 2011 09:56:53 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: Ivan Djelic <ivan.djelic@parrot.com>
CC: Robert Jarzmik <robert.jarzmik@free.fr>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH v3 13/16] mtd/docg3: add ECC correction code
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr> <1321714978-24543-14-git-send-email-robert.jarzmik@free.fr> <20111124102453.GF28830@parrot.com>
In-Reply-To: <20111124102453.GF28830@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 02:24 AM, Ivan Djelic wrote:
> On Sat, Nov 19, 2011 at 03:02:55PM +0000, Robert Jarzmik wrote:
>> Credit for discovering the BCH algorith parameters, and bit
>> reversing algorithm is to be give to Mike Dunn and Ivan
>> Djelic.
>>
>> The BCH correction code relied upon the BCH library, where
>> all data and ECC is bit-reversed. The BCH library works
>> correctly when each input byte is bit-reversed, and
>> accordingly ECC output is also bit-reversed.
>>
> Reviewed-by: Ivan Djelic <ivan.djelic@parrot.com>
>
>


Reviewed-by: Mike Dunn <mikedunn@newsguy.com>

