Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab1EXHqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:46:10 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2125 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1EXHqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:46:08 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4DDB622B.1050005@broadcom.com>
Date: Tue, 24 May 2011 09:45:47 +0200
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
In-Reply-To: <20110522151959.7fd6e87e@lxorguk.ukuu.org.uk>
X-WSS-ID: 61C5BC9F3IC4901157-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 04:19 PM, Alan Cox wrote:
> Is it just used for wireless in this form ?
>
> See the n_gsm and bluetooth code for what I think is the same crc
> algorithm but in reverse bit order .

Hi Alan,

Look into the code in n_gsm and bluetooth code. The algorithm is the 
same, but except for the bit order it also is using a different 
polynomial. My current implementation has a fixed table. I could do the 
table generation runtime with the polynomial and the bit order as 
parameters. That would make it more general purpose.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


