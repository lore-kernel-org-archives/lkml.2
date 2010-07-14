Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0GNTDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:03:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53779 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab0GNTDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:03:05 -0400
Message-ID: <4C3E09E4.7010904@zytor.com>
Date: Wed, 14 Jul 2010 12:03:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ben Greear <greearb@candelatech.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com>	<4C3D101E.5010605@candelatech.com>	<20100713191958.260478c0@virtuousgeek.org>	<4C3E077C.9040609@zytor.com> <20100714115904.7004be74@virtuousgeek.org>
In-Reply-To: <20100714115904.7004be74@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:59 AM, Jesse Barnes wrote:
> 
> Changes look ok to me, though I'd prefer not hitting this code at all
> on non-Moorestown if at all possible.
> 

I guess that's okay in the short term, but I'm guessing fixed BARs in
some form is eventually going to make it into the general PCI spec.

	-hpa

