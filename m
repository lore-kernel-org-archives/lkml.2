Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0CXWhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:37:37 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35108 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab0CXWhf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:37:35 -0400
X-Greylist: delayed 1667 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2010 18:37:34 EDT
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Mar 2010 23:09:37 +0100
Subject: RE: [PATCH 2/2] DMAENGINE: COH 901 318 fix bytesleft
Thread-Topic: [PATCH 2/2] DMAENGINE: COH 901 318 fix bytesleft
Thread-Index: AcrLmd4hw6D2VNy8RL29FWILux9ohgABKUog
Message-ID: <CEE6BB42CAD6E947908279175AF8470A0391EEB8@EXDCVYMBSTM006.EQ1STM.local>
References: <1267710030-5717-1-git-send-email-linus.walleij@stericsson.com>
 <e9c3a7c21003241435j25b63c05l5df2aa44fc5dc627@mail.gmail.com>
In-Reply-To: <e9c3a7c21003241435j25b63c05l5df2aa44fc5dc627@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan]

>> Subject: Re: [PATCH 2/2] DMAENGINE: COH 901 318 fix bytesleft
> 
> Should this hunk be broken off and sent to -stable?

Nah, just stack it up for -next, no hurries.

Yours,
Linus Walleij
