Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab1EWUVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:21:18 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2659 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1EWUVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:21:17 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4DDAC1A5.20004@broadcom.com>
Date: Mon, 23 May 2011 22:20:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "George Spelvin" <linux@horizon.com>
cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
References: <20110522152503.16429.qmail@science.horizon.com>
In-Reply-To: <20110522152503.16429.qmail@science.horizon.com>
X-WSS-ID: 61C41D141IC11024938-03-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 05:25 PM, George Spelvin wrote:
> #define POLY 0xAB	/* 1 + x^2 + x^4 + x^6 + x^7 (+ x^8) */
> typedef uint8_t crc_type;	/* Must be an unsigned type */
>

I think I understand the code a bit better. Your code is generic for any 
given crc_type.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


