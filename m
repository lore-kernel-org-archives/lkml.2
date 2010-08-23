Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab0HWSDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 14:03:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0HWSDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 14:03:40 -0400
Date: Mon, 23 Aug 2010 13:47:55 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Manu Abraham <abraham.manu@gmail.com>, Scott Davilla <davilla@4pi.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/18 v2] staging: crystalhd: call disable_pci_device()
 if pci_probe() failed
Message-ID: <20100823174755.GG28475@redhat.com>
References: <1281383506-14438-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281383506-14438-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:51:44PM +0400, Kulikov Vasiliy wrote:
> Driver should call disable_pci_device() if it returns from pci_probe()
> with error.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Looks fine by me.

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

