Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0JQKVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:21:39 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35084 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0JQKVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:21:38 -0400
Subject: Re: [PATCH] checkpatch: allow single space before labels
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
	 <1287303678.20968.37.camel@Joe-Laptop>
	 <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 12:21:29 +0200
Message-ID: <1287310889.1998.153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 04:24 -0400, Mike Frysinger wrote:

> feel free to extend however as long as the end result is no warnings
> for " foo:" ;).

I utterly detest those indented labels and am eradicating them wherever
I notice them. There's really no sane reason to use them what so ever.
Diff can be taught not to get confused about them, see my earlier email.

