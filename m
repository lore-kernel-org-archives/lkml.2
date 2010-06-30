Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0F3XGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:06:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59011 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862Ab0F3XGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:06:15 -0400
Message-ID: <4C2BCDC6.1010004@zytor.com>
Date: Wed, 30 Jun 2010 16:05:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: djwong@us.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, muli@il.ibm.com,
       cschultz@linux.vnet.ibm.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH] x86, Calgary: Increase max PHB number
References: <20100624212647.GI15515@tux1.beaverton.ibm.com> <tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org> <20100629155151.7caaff4b.akpm@linux-foundation.org> <4C2BB7C0.9040000@zytor.com> <20100630214923.GP15515@tux1.beaverton.ibm.com>
In-Reply-To: <20100630214923.GP15515@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:49 PM, Darrick J. Wong wrote:
> Newer systems (x3950M2) can have 48 PHBs per chassis and 4 chassis, so bump the
> limits up and provide an explanation of the requirements for each class.  Since
> we can't have more than 256 PCI buses in these systems, we don't need the array
> check.

The 384-entry patch is already upstream.  Can you send a patch relative
to current -linus?

	-hpa

