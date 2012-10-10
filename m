Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2JJQX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:23:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:46029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2JJQX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:23:26 -0400
Message-ID: <1349886164.1279.20.camel@twins>
Subject: Re: Meaningless load?
From: Peter Zijlstra <peterz@infradead.org>
To: Simon Klinkert <simon.klinkert@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com,
        Trond.Myklebust@netapp.com
Date: Wed, 10 Oct 2012 18:22:44 +0200
In-Reply-To: <98F2F644-D531-42FE-B080-9561142D71C8@gmail.com>
References: <98F2F644-D531-42FE-B080-9561142D71C8@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 17:44 +0200, Simon Klinkert wrote:
> I'm just wondering if the 'load' is really meaningful in this
> scenario. The machine is the whole time fully responsive and looks
> fine to me but maybe I didn't understand correctly what the load
> should mean. Is there any sensible interpretation of the load?

I'll leave meaningful aside, but uninterruptible (D state) is part of
how the load thing is defined, so your 500 result is correct.
