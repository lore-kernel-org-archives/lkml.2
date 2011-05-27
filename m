Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1E0S6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:58:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2133 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1E0S6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:58:15 -0400
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: anish <anish198519851985@gmail.com>, davej@redhat.com, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <1306521941.31864.19.camel@Joe-Laptop>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520217.3857.31.camel@gandalf.stny.rr.com>
	 <1306521941.31864.19.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 11:58:13 -0700
Message-ID: <1306522693.31864.23.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 11:45 -0700, Joe Perches wrote:
> But that's out of ~3.5 million non-merge commits.

Oops. Off by an order magnitude, stupid fingers.

$ git log --pretty=oneline --no-merges  | wc -l
232816

