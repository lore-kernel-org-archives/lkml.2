Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab0JZQhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:37:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55838 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab0JZQhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:37:53 -0400
Date: Tue, 26 Oct 2010 18:37:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, kvm@vger.kernel.org, avi@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: fyi: gcc33-hammer crashes when compiling kvm emulate.c
Message-ID: <20101026163748.GB29961@basil.fritz.box>
References: <20101026123828.GA30434@basil.fritz.box>
 <4CC70333.80400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC70333.80400@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We have said 3.4 minimum for x86 for a long time now, and have an RFC

Ok makes sense. I thought it was still at 3.3. I should retire
this 3.3 fossil anyways, it's really only for old compat testing.

I don't remember seeing a warning -- aren't there supposed to be warnings
for unsupported compilers?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
