Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1BBR3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:29:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52964 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab1BBR3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:29:39 -0500
Message-ID: <4D49946D.8010800@zytor.com>
Date: Wed, 02 Feb 2011 09:29:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
References: <20110202112139.GD14984@redhat.com> <4D4990F8.5020204@zytor.com> <20110202172534.GA24871@redhat.com>
In-Reply-To: <20110202172534.GA24871@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 09:25 AM, Gleb Natapov wrote:
> According to spec length should be set to 30 on exit.

I don't really know how this comment relates to the code, but in the
code I saw a fixed number of bytes being checksummed, which is
definitely wrong.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

