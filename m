Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2GTVgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:36:41 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3782 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2GTVgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:36:39 -0400
Message-ID: <1342820197.5434.54.camel@lorien2>
Subject: Re: [PATCH RFT] net: Fix Neptune ethernet driver to check dma
 mapping error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: David Miller <davem@davemloft.net>
Cc: mcarlson@broadcom.com, bhutchings@solarflare.com, eric.dumazet@gmail.com,
        mchan@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 20 Jul 2012 15:36:37 -0600
In-Reply-To: <20120720.143005.135422510157595877.davem@davemloft.net>
References: <1342819679.5434.50.camel@lorien2>
	 <20120720.143005.135422510157595877.davem@davemloft.net>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-20 at 14:30 -0700, David Miller wrote:
> From: Shuah Khan <shuah.khan@hp.com>
> Date: Fri, 20 Jul 2012 15:27:59 -0600
> 
> > Request for testing, since I don't have the hardware to test.
> 
> This is not how you post a patch.
> 
> > --------------------------------------------------------------------
> 
> When you put those "---..." there, GIT is going to eliminate everything
> afterwards from the commit mesage when I apply this.  Yet afterwards
> is what your commit message actually is.
> 
> You therefore should do things the other way around, provide the commit
> message text, then the "---..." line, then your comments you don't want
> in the final commit message.

Thanks. I had it reversed in my head for some reason. Maybe not enough
coffee :) Will resend the patch now.

-- Shuah

