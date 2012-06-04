Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab2FDL4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab2FDL4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:56:54 -0400
Date: Mon, 4 Jun 2012 14:56:50 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kvm segfaults and bad page state in 3.4.0
Message-ID: <20120604115650.GH23670@redhat.com>
References: <20120604114603.GA6988@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604114603.GA6988@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 07:46:03PM +0800, Fengguang Wu wrote:
> Hi,
> 
> I'm running lots of kvm instances for doing kernel boot tests.
> Unfortunately the test system itself is not stable enough, I got scary
> errors in both kvm and the host kernel. Like this. 
> 
What do you mean by "in both kvm and the host kernel". Do you have
similar Oopses inside your guests? If yes can you post one?

--
			Gleb.
