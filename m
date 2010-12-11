Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0LKAEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:04:39 -0500
Received: from mail-gy0-f194.google.com ([209.85.160.194]:59081 "EHLO
	mail-gy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab0LKAEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:04:38 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
Organization: Deep Root Systems, LLC
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
	<AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
Date: Fri, 10 Dec 2010 16:04:32 -0800
In-Reply-To: <AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
	(Ben Gardiner's message of "Fri, 10 Dec 2010 11:33:41 -0500")
Message-ID: <87lj3x899r.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, 
Ben Gardiner <bengardiner@nanometrics.ca> writes:

[...]

>> One minor question: the series has a couple of Signed-off-by tags from
>> Sekhar Nori.  The s-o-b tag is for folks on the delivery path, and based
>> on what I saw, these should probably be Acked-by tags from Sekhar, since
>> he certainly helped on the review/test/validate side, but AFAICT, was
>> not an author or on the delivery path.  If I'm wrong on this (e.g., if
>> Sekhar actually did author some of those patches) let me know, otherwise
>> I'll change the s-o-b to Acked-by for Sekhar.
>
> The s-o-b 's for Sehkar are because I folded-in suggested changes
> submitted in review by Sehkar in the form of a patch. I 'think' this
> qualifies as authorship. I'll leave it to your good judgement.

OK, thanks for clarification.   I'll leave the s-o-b tags as is.

Kevin

