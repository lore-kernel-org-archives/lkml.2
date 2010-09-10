Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0IJUhV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:37:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0IJUhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:37:19 -0400
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic
 constants
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 22:37:07 +0200
Message-ID: <1284151027.402.123.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 10:51 +0800, Huang Ying wrote:
> +       return inb(NMI_REASON_PORT);

I've always wondered, where is this magic stuff documented?


