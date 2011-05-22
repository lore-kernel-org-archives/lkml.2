Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1EVPjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 11:39:13 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3197 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1EVPjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 11:39:09 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DD92E09.5000201@broadcom.com>
Date: Sun, 22 May 2011 17:38:49 +0200
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
X-WSS-ID: 61C7F1624NS10714582-01-01
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
>
I only searched for term 'crc8' in the tree so you may be right. I will 
take a look. It may be worth to support both bit directions in some fashion.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


