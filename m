Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1KTX0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 18:26:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43005 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab1KTX03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 18:26:29 -0500
Message-ID: <4EC98C97.50604@kernel.org>
Date: Sun, 20 Nov 2011 15:26:15 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's
 exception table.
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <1321645068-20475-2-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1321645068-20475-2-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 11:37 AM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Using this build-time sort saves time booting as we don't have to burn
> cycles sorting the exception table.
> 

If we're going to do this at build time, I would suggest using a
collisionless hash instead.  The lookup time for those are O(1), but
they definitely need to be done at build time.

	-hpa

