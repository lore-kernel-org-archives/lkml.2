Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1HBNly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:41:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42578 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1HBNlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:41:49 -0400
Message-ID: <4E37FE95.7090808@ti.com>
Date: Tue, 2 Aug 2011 14:41:41 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: regulator: max8952 init a mutex but never use it
References: <1312287360.2372.1.camel@phoenix>
In-Reply-To: <1312287360.2372.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 13:16, Axel Lin wrote:
> hi,
> The max8952 regulator driver init a mutex but never use it,
> do we really need the mutex? Or should we just remove it?
> 

It can be removed if it is not being used anywhere.

Liam
