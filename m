Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1IZURg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 16:17:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60171 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1IZURf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 16:17:35 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 26 Sep 2011 22:16:04 +0200
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317068164.1763.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 12:13 -0700, John Stultz wrote:
> 
> For now, I'd just be interested in what folks think about the concept with
> regards to the wakelock discussions. Where it might not be sufficient? Or
> what other disadvantages might it have? Are there any varients to this
> idea that would be better? 

I would like to know why people still think wakelocks are remotely sane?

>From where I'm sitting they're utter crap.. _WHY_ do you need to suspend
anything? What's wrong with regular idle?

So no, you've got a massive major NAK for anything touching the
scheduler for this utter braindamage.
