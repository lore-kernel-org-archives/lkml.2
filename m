Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0K3UTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:19:38 -0500
Received: from mail.perches.com ([173.55.12.10]:2028 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab0K3UTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:19:37 -0500
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to
 ath_debug
From: Joe Perches <joe@perches.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: peter@stuge.se, ath9k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CF464D6.2020507@openwrt.org>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
	 <20101129060732.5130.qmail@stuge.se>  <4CF42C17.2070500@openwrt.org>
	 <1291081185.16349.133.camel@Joe-Laptop>  <4CF464D6.2020507@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 12:19:35 -0800
Message-ID: <1291148375.18026.342.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 03:43 +0100, Felix Fietkau wrote:
> On 2010-11-30 2:39 AM, Joe Perches wrote:
> > I gauge my willingness to spend time on subsystems on
> > the maintainers willingness to merge things that improve
> > readability and correctness.
> I'm not trying to discourage you from spending time on improving this
> code, just doubting the usefulness of such simple function renames.

Poor function naming is just that.
It reduces readability and the uses are counter expectation.



