Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2DFBCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 21:02:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45412 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2DFBCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 21:02:07 -0400
Date: Thu, 5 Apr 2012 22:01:59 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
Message-ID: <20120406010159.GA2981@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@intel.com>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com>
 <20120329022839.GA26111@joana>
 <86r4wct9q7.fsf@sumi.keithp.com>
 <20120330065456.GA9173@joana>
 <86wr5takat.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wr5takat.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

* Keith Packard <keithp@keithp.com> [2012-04-05 15:24:58 -0700]:

> <#part sign=pgpmime>
> On Fri, 30 Mar 2012 03:54:56 -0300, Gustavo Padovan <gustavo@padovan.org> wrote:
> 
> > Can you try the following patch? It should fix the compatibility
> > problem you had.
> 
> Yes, the kernel with that patch (without the revert) works now.

Thanks for testing, I will push this to mainline ASAP.

	Gustavo
