Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1JMIfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:35:31 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:41345 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1JMIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:35:29 -0400
Subject: Re: [PATCH] [TRIVIAL] parisc: Kconfig: cleanup Kernel page size
 default
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4E96A14C.5050408@suse.cz>
References: <1318423872.2336.19.camel@x61.thuisdomein>
	 <4E96A14C.5050408@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 10:35:16 +0200
Message-ID: <1318494916.8345.17.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 10:29 +0200, Michal Marek wrote:
> On 12.10.2011 14:51, Paul Bolle wrote:
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > "Kernel page size" still defaults to "4KB", for both 32 and 64 bit
> > processors, when tested with "make ARCH=parisc menuconfig", which is
> > good.
> 
> I think this paragraph would be nice to have in the changelog.

Fine with me. Jiri, should I amend my patch and resend?


Paul Bolle

