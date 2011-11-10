Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455Ab1KJFK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:10:28 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40776 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437Ab1KJFKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 00:10:23 -0500
X-Sasl-enc: RRwePb+baJCitxM5YbU89+9PSvabNbrxuuONT78lY9za 1320901822
Date: Wed, 9 Nov 2011 20:48:01 -0800
From: Greg KH <greg@kroah.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] [2.6.32-stable] mm: avoid null pointer access in
 vm_struct via /proc/vmallocinfo
Message-ID: <20111110044801.GA24277@kroah.com>
References: <20111107182439.GA5806@kroah.com>
 <20111110043716.11274.32615.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110043716.11274.32615.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 01:37:16PM +0900, Mitsuo Hayasaka wrote:
> This patch is the backport version of the patch which solves a null
> pointer access in vm_struct via /proc/vmallocinfo.

What is the commit id of the version of this patch in Linus's tree?

thanks,

greg k-h
