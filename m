Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab0I0ARI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:17:08 -0400
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:37789 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754486Ab0I0ARG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:17:06 -0400
Message-ID: <4C9FE27D.80407@fluff.org>
Date: Mon, 27 Sep 2010 01:17:01 +0100
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Simon Richter <Simon.Richter@hogyros.de>
CC: Darius Augulis <augulis.darius@gmail.com>, kgene.kim@samsung.com,
        Ben Dooks <ben-linux@fluff.org>, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
References: <20100923190212.18863.25678.stgit@darius-desktop>	<4C9BE577.4050504@fluff.org>	<AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com> <20100924073453.GA3840@richter>
In-Reply-To: <20100924073453.GA3840@richter>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/10 08:34, Simon Richter wrote:
> Hi,
> 
> On Fri, Sep 24, 2010 at 09:57:19AM +0300, Darius Augulis wrote:
> 
>> It does - now devices are named /dev/s3c2410_serial, and patch changes
>> its name to /dev/ttySAC
> 
> I wonder if it'd make sense to name them ttyS[0-9]. I've never
> understood why the platform standard fixed serial ports on any device
> should have a different name.

Different driver. And yes, we've built systems with both this and
an 8250 base chip.
