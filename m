Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab0H0MCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:02:50 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:47353 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab0H0MCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:02:47 -0400
Message-ID: <4C77A92F.8020302@euromail.se>
Date: Fri, 27 Aug 2010 14:01:51 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 3/4] identify firmware version
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu> <1282798497-19791-4-git-send-email-rafi@seas.upenn.edu>
In-Reply-To: <1282798497-19791-4-git-send-email-rafi@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Ooxdc-0000kr-6m.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Ooxdc-0000kr-6m 25db98f9c26a95ba3aad67d7baf34287
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 06:54 AM, Rafi Rubin wrote:

> This adds firmware version polling to the end of probe and reports the
> version both in the raw form and proccessed to match the formatting used
> by ntrig in windows.
> 
> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>


The version field of the input_id struct is a 16-bit number that can be used to
code device-specific version information, and is retrievable via EVIOCGID.
Perhaps one could code the firmware version in there.

Henrik
