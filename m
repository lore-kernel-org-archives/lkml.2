Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0K2Wli (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:41:38 -0500
Received: from nbd.name ([46.4.11.11]:51864 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0K2Wlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:41:37 -0500
Message-ID: <4CF42C17.2070500@openwrt.org>
Date: Mon, 29 Nov 2010 23:41:27 +0100
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: peter@stuge.se
CC: ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
 ath_debug
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>	<AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com> <20101129060732.5130.qmail@stuge.se>
In-Reply-To: <20101129060732.5130.qmail@stuge.se>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-29 7:07 AM, Peter Stuge wrote:
> Luis R. Rodriguez wrote:
>> On Sun, Nov 28, 2010 at 3:53 PM, Joe Perches <joe@perches.com> wrote:
>> > Make the function name match the function purpose.
>> > ath_debug is a debug only facility.
>> > ath_print seems too generic a name for a debug only use.
>> 
>> Nack, I don't see the point.
> 
> The point is to improve readability. I like the patch.
And how exactly does this improve readability? Don't get me wrong, I
generally like to see more cleanups merged to the ath/ath9k drivers
(they do need it, after all).

But in my opinion, simple renaming churn like this does nothing but
annoy people who want to get other work done at the same time.
Consider the large number of lines touched (and the potential merge
conflicts with other code because of that), relative to the microscopic
aesthetic gain (if any).

Instead I'd like to see more cleanups that go beyond trivial function
renames.

- Felix
