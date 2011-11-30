Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab1K3OZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:25:02 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52944 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab1K3OZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:25:00 -0500
Date: Wed, 30 Nov 2011 12:24:47 -0200
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into infinite
 spin in RT
Message-ID: <20111130142447.GA5271@uudg.org>
References: <1322618120.17003.104.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1322618120.17003.104.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 08:55:20PM -0500, Steven Rostedt wrote:
...
| I booted this patch against 3.0-rt stable, and it didn't crash ;)
| Could you apply it and see if it fixes the hang that you've been seeing.

Steven,

I have a test box that would present the issue every 2 or 3 reboots,
consistently. Using your patch I have already rebooted the box 30 times
successfuly. And the test keeps going on... I feel confident to add my:

Tested-by: Luis Claudio R. Gonçalves <lgoncalv@redhat.com>

Cheers,
Luis

