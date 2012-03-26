Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2CZWpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:45:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53270 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2CZWpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120326142908.c5248aec.akpm@linux-foundation.org>
References: <20120326180710.8DF9C9D401E@zog.reactivated.net>
	<20120326142908.c5248aec.akpm@linux-foundation.org>
Date: Mon, 26 Mar 2012 16:45:10 -0600
X-Google-Sender-Auth: 52PytxvE-oNTmkEx_wPcjKRq_uY
Message-ID: <CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
From: Daniel Drake <dsd@laptop.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net, pgf@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 3:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
> is based upon an earlier version from Paul then Signed-off-by: is
> correct.
>
> What's going on here?  What are you trying to communicate?

I'm trying to take Ingo's suggestion, in the thread "[patch 1/8] x86,
olpc: add debugfs interface for EC commands" he wrote:

====
This is not a valid signoff sequence - the 'From: ' author of
the patch must be the first SOB line.

The way to do this is either to have a:

 From: Paul Fox <pgf@laptop.org>

or to covert Paul Fox's SOB to a credit line, such as:

 Originally-from: Paul Fox <pgf@laptop.org>
====

The original code was from Paul Fox. I changed it somewhat
significantly, and Paul approves of the end result.
Can someone suggest a way of expressing this, including tag ordering,
that will be accepted by all parties?  :)

Thanks
Daniel
