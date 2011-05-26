Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1EZTLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:11:24 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1243 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab1EZTLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:11:23 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4DDEA5C7.70806@broadcom.com>
Date: Thu, 26 May 2011 21:11:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [RFC V4] lib: crc8: add new library module providing crc8
 algorithm
References: <1306320099-17970-1-git-send-email-arend@broadcom.com>
 <20110525094304.0769a189.rdunlap@xenotime.net>
In-Reply-To: <20110525094304.0769a189.rdunlap@xenotime.net>
X-WSS-ID: 61C079491IC12233315-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

I have moved couple of math functions into the lib directory in response 
to feedback you gave to Henry Ptasinski. Both patches had some 
iterations on the mailing lists covering feedback received from 
community members. I expect to send final patches for crc8 and cordic 
(fixed point sine/cosine calculation) soon. Are you willing to take 
these patches when 2.6.40-rc1 arrives?

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


