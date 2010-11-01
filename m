Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab0KANFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:05:45 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:36420 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab0KANFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:05:41 -0400
X-Greylist: delayed 1333 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 09:05:41 EDT
Date: Mon, 1 Nov 2010 08:43:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ben Gamari <bgamari.foss@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Add Kconfig option for default swappiness
Message-ID: <20101101124322.GG840@cmpxchg.org>
References: <1288548508-22070-1-git-send-email-bgamari.foss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288548508-22070-1-git-send-email-bgamari.foss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 02:08:28PM -0400, Ben Gamari wrote:
> This will allow distributions to tune this important vm parameter in a more
> self-contained manner.

What's wrong with sticking

	vm.swappiness = <your value>

into the shipped /etc/sysctl.conf?
