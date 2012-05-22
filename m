Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178Ab2EVX3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 19:29:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab2EVX3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 19:29:47 -0400
Date: Tue, 22 May 2012 16:29:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        LKML <linux-kernel@vger.kernel.org>, khlebnikov@openvz.org,
        markus@trippelsdorf.de, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org
Subject: Re: 3.4-rc7: BUG: Bad rss-counter state mm:ffff88040b56f800 idx:1
 val:-59
Message-Id: <20120522162946.2afcdb50.akpm@linux-foundation.org>
In-Reply-To: <20120522162835.c193c8e0.akpm@linux-foundation.org>
References: <4FBC1618.5010408@fold.natur.cuni.cz>
	<20120522162835.c193c8e0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012 16:28:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I notice that I don't have this tagged for -stable backporting.  That
> seems wrong.  Konstantin, do we know for how long this bug has been in
> there?

Also, I have a note here that Oleg was unhappy with the patch.  Oleg
happiness is important.  Has he cheered up yet?

