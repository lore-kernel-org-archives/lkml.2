Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0ITUIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:08:43 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49205 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757348Ab0ITUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:08:41 -0400
Message-ID: <4C97BEED.202@euromail.se>
Date: Mon, 20 Sep 2010 22:07:09 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100916 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] hid: 3m: Complete MT support
References: <1283005652-3198-1-git-send-email-rydberg@euromail.se> <0E2212A1-A312-4477-B309-25C1C5332EE5@enac.fr>
In-Reply-To: <0E2212A1-A312-4477-B309-25C1C5332EE5@enac.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Oxmdp-0004nk-64.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Oxmdp-0004nk-64 4f544ee6a2d3a6f1fce2c0ce9df69fff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 08:16 PM, Stéphane Chatty wrote:

> 
> Le 28 août 10 à 16:27, Henrik Rydberg a écrit :
> 
>> Jiri, Stephane, Dmitry,
>>
>> Please find enclosed a set of patches which enables full support for
>> the 60-finger, 22-inch 3M touchscreen. Two of the patches fix actual
>> problems, and one patch converts the driver to the MT slots protocol.
> 
> I'll comment each patch individually, but a general comment first: Henrik, you
> should add yourself and/or your employer to the copyright notice.


Thanks Stéphane. I will send an adjusted or additional patch once we know if
there will be any other changes.

Cheers,
Henrik
