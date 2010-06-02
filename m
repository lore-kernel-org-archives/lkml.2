Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0FBHLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:11:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33742 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab0FBHLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:11:54 -0400
Date: Wed, 2 Jun 2010 09:11:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: norsk5@yahoo.com, hpa@zytor.com, tglx@linutronix.de,
       linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/6] x86, mce: Notify about corrected events too
Message-ID: <20100602071141.GB17765@elte.hu>
References: <1275398971-12439-1-git-send-email-bp@amd64.org>
 <1275398971-12439-5-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275398971-12439-5-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1790]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Notify all parties registered on the mce decoder chain about logged
> correctable MCEs.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
