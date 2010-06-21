Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0FULCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:02:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab0FULCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:02:45 -0400
Subject: Re: [patch] x86, pat: freeing invalid memtype messages
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Dan Carpenter <error27@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
In-Reply-To: <4C1F455E.6050502@redhat.com>
References: <20100617134559.GA29824@bicker> <20100617161728.GA2741@joi.lan>
	 <4C1B1691.6020809@redhat.com> <20100618175726.GA2785@joi.lan>
	 <4C1F455E.6050502@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Jun 2010 13:02:35 +0200
Message-ID: <1277118155.1875.508.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 18:56 +0800, Xiaotian Feng wrote:

> I guess there might be something wrong between the augmented rbtree insert/remove ..

The easiest thing is to revert that change and try again, the next step
would be to print the full RB tree on each modification and look where
it goes wrong.

That said, I did print my fair share of (augmented) RB trees while
playing with scheduler patches and I can't remember it ever having
messed up like that.
