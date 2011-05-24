Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1EXKjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:39:01 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4908 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1EXKjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:39:00 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4DDB8AB5.7080808@broadcom.com>
Date: Tue, 24 May 2011 12:38:45 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306010973-5625-1-git-send-email-arend@broadcom.com>
 <20110522122325.108b1c86@lxorguk.ukuu.org.uk>
 <4DD905CC.8040407@broadcom.com>
 <20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
 <4DDB622B.1050005@broadcom.com>
 <20110524104404.336c765f@lxorguk.ukuu.org.uk>
 <4DDB81FD.2020903@broadcom.com>
 <20110524112732.67d92b2f@lxorguk.ukuu.org.uk>
In-Reply-To: <20110524112732.67d92b2f@lxorguk.ukuu.org.uk>
X-WSS-ID: 61C554241IC11239427-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 12:27 PM, Alan Cox wrote:
>> Not sure whether you mean the source code or the object code. I build
>> kernel with debug symbols so the sizes are bit higher.
> nm will tell you the actual sizes. I think the n_gsm code is about 500
> bytes or so and chunks of it inline.

Not counting the crc table I assume.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


