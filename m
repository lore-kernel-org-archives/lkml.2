Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2JCPQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:16:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38549 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605Ab2JCPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:16:35 -0400
Message-ID: <506C56B2.50505@zytor.com>
Date: Wed, 03 Oct 2012 08:16:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Daniel J Blueman <daniel@numascale-asia.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steffen Persvold <sp@numascale.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: Fix AMD Northbridge-ID contiguity assumptions
References: <1349256029-14851-1-git-send-email-daniel@numascale-asia.com>
In-Reply-To: <1349256029-14851-1-git-send-email-daniel@numascale-asia.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:20 AM, Daniel J Blueman wrote:
> The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
> are contiguous, which no longer holds on federated systems with multiple
> HyperTransport fabrics with multiple PCI domains.

Is that "on NumaScale systems"?  If so, please say so rather than trying
to make it sound generic; if it is not, can you give some other examples?

	-hpa
