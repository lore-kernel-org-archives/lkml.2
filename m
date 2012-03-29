Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab2C2DuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:50:19 -0400
Received: from home.keithp.com ([63.227.221.253]:60690 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2C2Dtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:49:51 -0400
From: Keith Packard <keithp@keithp.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>
Subject: Re: [PATCH] Revert "Bluetooth: Always enable management interface"
In-Reply-To: <20120329022839.GA26111@joana>
References: <1332983958-2734-1-git-send-email-keithp@keithp.com> <20120329022839.GA26111@joana>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 28 Mar 2012 20:48:21 -0700
Message-ID: <86d37w9iey.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Wed, 28 Mar 2012 23:28:39 -0300, Gustavo Padovan <gustavo@padovan.org> wrote:

> $ bluetoothd -P mgmtops
> 
> Then your bluetooth will be back.

Indeed. Please fix the kernel so that existing user space works again.

-- 
keith.packard@intel.com
