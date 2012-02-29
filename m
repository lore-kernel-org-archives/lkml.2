Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2B2IbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:31:07 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:58814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2B2IbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:31:06 -0500
Subject: Re: [PATCH] mac80211: improve PID rate control mechanism by
 avoiding rate oscillation problem
From: Johannes Berg <johannes@sipsolutions.net>
To: YIN Wei <yinwei168@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        mattias.nissler@gmx.de, stefano.brivio@polimi.it
In-Reply-To: <CAFxU49=OASHEDc2m8BfCGD6_gHcr6SFaap+b9ZnErWhNWFG8oQ@mail.gmail.com> (sfid-20120229_031816_008358_36E52A04)
References: <CAFxU49=OASHEDc2m8BfCGD6_gHcr6SFaap+b9ZnErWhNWFG8oQ@mail.gmail.com>
	 (sfid-20120229_031816_008358_36E52A04)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Feb 2012 09:31:03 +0100
Message-ID: <1330504263.4714.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 12:17 +1000, YIN Wei wrote:
> From: Wei YIN

You want an email address here,

> Improve PID rate control mechanism by solving the rate oscillation
> problem. Current PID mechanism is based on a PID  controller which
> tries to minimise the difference between the frame loss ratio (FLR)
> and the target FLR. Therefore it is straight forward that it increases
> to a higher rate when the FLR is less than the target without thinking
> whether the higher rate can be supported. If the higher rate cannot be
> supported, significant FLR will occur, which causes the mechanisms to
> decrease the rate sharply. The proposed approach only updates the rate
> when the proposed rate by the PID controller can achieve better
> throughput than the old rate. This patch applies to kernel 3.3.0.
> Signed-off-by: Wei YIN

and here.

Also since you sent as HTML, it never made it to the list and can't be
applied as a patch, care to resend?

johannes


