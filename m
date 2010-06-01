Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab0FAKoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:44:37 -0400
Received: from www.tglx.de ([62.245.132.106]:41793 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705Ab0FAKog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:44:36 -0400
Date: Tue, 1 Jun 2010 12:43:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Mickler <florian@mickler.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, 640e9920@gmail.com,
       markgross@thegnar.org, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] pm_qos: remove unnecessary list-traversal
In-Reply-To: <1275382331-15180-1-git-send-email-florian@mickler.org>
Message-ID: <alpine.LFD.2.00.1006011240360.2933@localhost.localdomain>
References: <1275382014-10178-1-git-send-email-florian@mickler.org> <1275382331-15180-1-git-send-email-florian@mickler.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, florian@mickler.org wrote:

> The new extreme value is only depending on the old extreme value and
> the changed value.

And how does that update to the next applicable constraint when the
current constraint is removed ? Your patch is creating a one way
decision.
 
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> This version actually compiles...  :)

That does not make it work.

     tglx
