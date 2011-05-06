Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1EFHWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 03:22:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1EFHV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 03:21:59 -0400
Date: Fri, 6 May 2011 03:16:54 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        "David S. Miller" <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 34/38] can: Add missing socket check in
 can/bcm release.
Message-ID: <20110506031654.4e2d6e9d@katamari>
In-Reply-To: <20110506001210.638661956@clark.kroah.org>
References: <20110506001225.GA10547@kroah.com>
	<20110506001210.638661956@clark.kroah.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 May 2011 17:11:06 -0700
Greg KH <gregkh@suse.de> wrote:

> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Dave Jones <davej@redhat.com>
> 
> commit c6914a6f261aca0c9f715f883a353ae7ff51fe83 upstream.
> 

Can we get the twin to that patch in too?

commit 10022a6c66e199d8f61d9044543f38785713cbbd
"can: add missing socket check in can/raw release"

