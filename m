Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1ACRHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:07:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45703 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1ACRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m80nOfep5dBX/I+xSMiFpt57JLP/pJt/j9kKAXT7iIwX3aMAHnviTBFS2Yo8tF8Ylt
         S8NlLCwpO5umjuvqXXPPJUEaM1GkWZLswHlyzyJS3PuoeoVygXiArS+4BoGkHY8h2Jq8
         +Jmw2UYmj36VIi1Q4NjLI0ZJy4yqBzbxA6LR0=
Date: Mon, 3 Jan 2011 18:07:34 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 7/8] ptp: Added a clock driver for the IXP46x.
Message-ID: <20110103170732.GA3700@riccoc20.at.omicron.at>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <d2e0a5ac5eb51e9e4c7fcc94723b67c72c2f57c1.1292512461.git.richard.cochran@omicron.at>
 <20110102084505.GA3980@ucw.cz>
 <20110102091233.GA2847@riccoc20.at.omicron.at>
 <20110102092042.GA14165@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110102092042.GA14165@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 02, 2011 at 10:20:42AM +0100, Pavel Machek wrote:
> Given the comments -- does manual really use camelCase crap?
> And... the identifiers actually combine camelCase with _. Better fix
> it.

Thats the way Intel likes it:

http://download.intel.com/design/network/manuals/30626204.pdf

Page 837

