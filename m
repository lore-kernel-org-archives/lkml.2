Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab0DGHpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 03:45:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab0DGHp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 03:45:29 -0400
Subject: Re: High priority threads causing severe CPU load imbalances
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@mit.edu>
Cc: Suresh Jayaraman <sjayaraman@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4BBC0D1E.3030509@mit.edu>
References: <4BBB334D.5040308@suse.de> <1270562890.1595.438.camel@laptop>
	 <4BBC0D1E.3030509@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Apr 2010 09:44:21 +0200
Message-ID: <1270626261.5109.538.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 00:42 -0400, Andy Lutomirski wrote:
> That's less fair but strictly better than the current solution, 
> and nothing bounces. 

The fairness thing, that really matters a lot to some people.

I've had enterprise bugs filed over such behaviour as you describe.
