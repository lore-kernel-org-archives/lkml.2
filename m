Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1IMALP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 20:11:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1IMALN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 20:11:13 -0400
Date: Tue, 13 Sep 2011 02:11:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Temporary -rcu tree location
In-Reply-To: <20110913000107.GA15945@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.1109130210090.19238@twin.jikos.cz>
References: <20110913000107.GA15945@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Sep 2011, Paul E. McKenney wrote:

> PS.  If someone knows how to make github delete a branch, please let me
>      know, as this would allow me to use the "rcu/next" nomenclature.
>      Yes, it is probably obvious, but I am new to github...

git push origin :branch should work everywhere, right?

-- 
Jiri Kosina
SUSE Labs

