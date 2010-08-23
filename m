Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0HWOFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:05:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0HWOFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:05:48 -0400
Subject: Re: help needed with EXPORT_SYMBOL
From: Peter Zijlstra <peterz@infradead.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: aijazbaig1@gmail.com, netfilter-devel@vger.kernel.org, jengelh@medozas.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	 <1282540448.4080.86.camel@aijazbaig1-desktop>
	 <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	 <1282569477.2605.1798.camel@laptop>
	 <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 16:05:46 +0200
Message-ID: <1282572346.2605.1856.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 09:44 -0400, Brian Gerst wrote:
> The assumption was that there was a single module using that hook.

Not really a future-proof design, is it?
