Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1BWPVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:21:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1BWPVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:21:02 -0500
Date: Wed, 23 Feb 2011 10:20:46 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: remove die_nmi()
Message-ID: <20110223152046.GA32012@redhat.com>
References: <4D5D521C0200007800032702@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5D521C0200007800032702@vpn.id2.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:51:40PM +0000, Jan Beulich wrote:
> With no caller left, the function and the DIE_NMIWATCHDOG enumerator
> can both go away.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Acked-by: Don Zickus <dzickus@redhat.com>
