Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1BKVi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:38:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56572 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1BKViZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:38:25 -0500
Message-ID: <4D55AC37.7020301@zytor.com>
Date: Fri, 11 Feb 2011 13:37:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, dilinger@queued.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add reboot=acpi quirk for OLPC XO-1.5
References: <20110211213221.B78DE9D401D@zog.reactivated.net>
In-Reply-To: <20110211213221.B78DE9D401D@zog.reactivated.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 01:32 PM, Daniel Drake wrote:
> The OLPC XO-1.5 needs the reboot=acpi flag to reboot correctly.
> Add a quirk so that this becomes the default.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

We keep talking about making this the default, let me check on the
status of that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

