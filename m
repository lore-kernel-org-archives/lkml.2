Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0DMF5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:57:31 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:53811 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab0DMF53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:57:29 -0400
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 01:57:28 EDT
Subject: Re: [PATCH 1/3] MFD: renamed ab3100.h to abx500.h
From: srinidhi <srinidhi.kasagar@stericsson.com>
Reply-To: <srinidhi.kasagar@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Mattias WALLIN <mattias.wallin@stericsson.com>
In-Reply-To: <1271113496-6744-1-git-send-email-linus.walleij@stericsson.com>
References: <1271113496-6744-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain
Organization: STE
Date: Tue, 13 Apr 2010 11:00:56 +0530
Message-ID: <1271136656.22314.3.camel@bnru03>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, 2010-04-13 at 01:04 +0200, Linus Walleij wrote:
> The goal here is to make way for a more general interface for the
> analog baseband chips ab3100 ab3550 ab550 and future chips.

So do you expect the existing ab4500 also to be merged into abx500?

regards,
Srinidhi


