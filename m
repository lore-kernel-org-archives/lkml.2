Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0KOEWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 23:22:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab0KOEWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 23:22:32 -0500
Message-ID: <4CE0B54E.6000101@zytor.com>
Date: Sun, 14 Nov 2010 20:21:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andres Salomon <dilinger@queued.net>, Milton Miller <miltonm@bga.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
References: <20101111214546.4e573cad@queued.net> <reply-olpc-3-v2@mdm.bga.com> <20101112002704.50c629e2@queued.net> <20101114095013.GB24206@elte.hu>
In-Reply-To: <20101114095013.GB24206@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 01:50 AM, Ingo Molnar wrote:
> 
> It's being frowned upon btw, because it's easy to overlook (and for other reasons) - 
> please dont use statics inside functions - please put them in front of the function 
> or further up into file scope.
> 

What?  What is wrong with static variables in functions?  It really
doesn't seem to be a good idea to make them file-scope if they don't
need to be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

