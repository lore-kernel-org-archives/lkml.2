Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1AZEQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:16:46 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65368 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1AZEQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3P5VWv2PA3R9=UZtwBkUxauhVGyCAzp_XNTBp@mail.gmail.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
 <1295834493-5019-29-git-send-email-ccross@android.com> <AANLkTimKqkKFuKCKPV2jSjUtPqo4tbonwR1iO2rsrK1r@mail.gmail.com>
 <AANLkTi=3P5VWv2PA3R9=UZtwBkUxauhVGyCAzp_XNTBp@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jan 2011 21:16:24 -0700
X-Google-Sender-Auth: S-4LLTGHLgrx_vUxlT71u0yn5bA
Message-ID: <AANLkTimxUyk7NSoKXb0CeQq9it2vnZ4T4mecQyUXC2gG@mail.gmail.com>
Subject: Re: [PATCH v2 28/28] ARM: tegra: clock: Add forward reference to
 struct clk
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net, konkers@android.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 8:21 PM, Colin Cross <ccross@android.com> wrote:
> On Tue, Jan 25, 2011 at 7:19 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Sun, Jan 23, 2011 at 7:01 PM, Colin Cross <ccross@android.com> wrote:
>>> Signed-off-by: Colin Cross <ccross@android.com>
>>
>> Hi Colin,
>>
>> This build warning exists in current mainline.  It should go out to
>> Linus now instead of waiting for 2.6.29.
>>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
>> g.
>
> It will, I just haven't sent it yet.  I have one more patch I'd like
> to send with it to prevent a possible variable name conflict in
> 2.6.39.

Cool, thx.

g.
