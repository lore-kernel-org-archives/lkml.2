Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0IPSt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:49:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab0IPSt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:49:57 -0400
Date: Thu, 16 Sep 2010 11:47:50 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Jan Blunck <jblunck@infradead.org>
Subject: Re: [PATCH 01/12] BKL: Remove BKL from usbfs
Message-ID: <20100916184750.GB8860@suse.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
 <1284659185-8942-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284659185-8942-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 07:46:14PM +0200, Arnd Bergmann wrote:
> Nothing in there has a race that can be
> prevented by holding the BKL.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Jan Blunck <jblunck@infradead.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
