Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab2AVC1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 21:27:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46826 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2AVC1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 21:27:43 -0500
Message-ID: <4F1B741C.3050903@lwfinger.net>
Date: Sat, 21 Jan 2012 20:27:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, wireless <linux-wireless@vger.kernel.org>,
        Alok Kataria <akataria@vmware.com>, Dan Hecht <dhecht@vmware.com>
Subject: Re: (Very old) Regression following commit bfc0f59
References: <4F1B71F5.6020000@lwfinger.net>
In-Reply-To: <4F1B71F5.6020000@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2012 08:18 PM, Larry Finger wrote:
> I recently discovered that an ancient laptop built by Mtech and containing an
> AMD K6 450/2 CPU was generating errors when using the Cardbus versions of
> Broadcom cards using either b43 of b43legacy. Expecting some change in those
> drivers or ssb, I found a kernel old enough to work without the error, and did a
> bisection. I was very surprised when "x86: merge tsc calibration", which is
> commit bfc0f5947afa5e3a13e55867f4478c8a92c11dca (dated July 1, 2008), turned out
> to be the source of the regression. It was verified by generating a reversion
> patch. One main difference is that the bad code gets a processor speed of
> 214.398 MHz, whereas reverting the commit yields 428.845 MHz, which is more in
> keeping with the stated frequency of 450 MHz. As the machine is more than 10
> years old, the clock may have drifted considerably.

The newest kernel that was running on this laptop was 3.2-rc4. When I updated to 
3.3-rc1, the problem above was fixed, thus nothing needs to be done.

Larry

