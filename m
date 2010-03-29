Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0C2TBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:01:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53460 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab0C2TBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:01:41 -0400
Message-ID: <4BB0F7DA.6080603@zytor.com>
Date: Mon, 29 Mar 2010 11:56:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Giel van Schijndel <me@mortis.eu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>	<1269523063-30346-1-git-send-email-me@mortis.eu>	<20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>	<20100325180347.GA2761@salidar.me.mortis.eu>	<20100325181633.0313b8a5@lxorguk.ukuu.org.uk>	<20100329081834.GB27956@salidar.me.mortis.eu>	<20100329090713.1317942b@jbarnes-piketon>	<20100329173800.GA3583@salidar.me.mortis.eu>	<4BB0E73F.2080104@zytor.com> <20100329193933.1a04762b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100329193933.1a04762b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 11:39 AM, Alan Cox wrote:
>> What I *really* object to with this patch is that it inherently assumes
>> that there is only one multiplexed resource in the entire system... but
>> of course nowhere enforces that.
> 
> The patch does nothing of the sort. Not unless there is a bug I am not
> seeing anyway. It does assume nobody tries to grab pairs of such
> resources as it doesn't do deadlock avoidance.
> 
> It's now a shared resource patch however, its a multiplexor patch and
> that is precisely why it is called MUX not SHARED or OVERLAY
> Alan

Sorry, I missed the "continue", which of course handles the situation I
was worried about.  The shared wait queue is a bit inelegant, but if it
turns out to be a bottleneck in real life then we either have bigger
problems or it can be addressed at that time.

	-hpa

