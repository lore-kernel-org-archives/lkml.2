Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2DEWZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:25:12 -0400
Received: from home.keithp.com ([63.227.221.253]:49662 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab2DEWZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:25:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
In-Reply-To: <20120330065456.GA9173@joana>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com> <20120329022839.GA26111@joana> <86r4wct9q7.fsf@sumi.keithp.com> <20120330065456.GA9173@joana>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 05 Apr 2012 15:24:58 -0700
Message-ID: <86wr5takat.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Fri, 30 Mar 2012 03:54:56 -0300, Gustavo Padovan <gustavo@padovan.org> wrote:

> Can you try the following patch? It should fix the compatibility
> problem you had.

Yes, the kernel with that patch (without the revert) works now.

-- 
keith.packard@intel.com
