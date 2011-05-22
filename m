Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1EVMty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 08:49:54 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1546 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1EVMtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 08:49:46 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4DD9065C.70107@broadcom.com>
Date: Sun, 22 May 2011 14:49:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Nicolas Kaiser" <nikai@nikai.net>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306051680-2354-1-git-send-email-arend@broadcom.com>
 <20110522105956.3b7a9fa2@absol.kitzblitz>
In-Reply-To: <20110522105956.3b7a9fa2@absol.kitzblitz>
X-WSS-ID: 61C7D8C93IC4283902-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 10:59 AM, Nicolas Kaiser wrote:
> * "Arend van Spriel"<arend@broadcom.com>:
>> +/**
>> + * crc8() - calculate a crc8 over the given input data
>> + *
>> + * @pdata:	pointer to data buffer.
>> + * @nbytes:	number of bytes in data buffer.
>> + * @crc:	previous returned crc8 value.
>> + *
>> + * The CRC8 is calculated using the polynomial given below.
>> + *
>> + * x^8 + x^7 +x^6 + x^4 + x^2 + 1
>                   ^
> Could you possibly add a space here ...
>
>> +/*
>> + * table for crc8 calculation based on following polynomial:
>> + *	x^8 + x^7 +x^6 + x^4 + x^2 + 1
>                     ^
>             ... and here?
>
> Best regards,
> Nicolas Kaiser
>

Done. Will wait for some more feedback before posting a new version.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


