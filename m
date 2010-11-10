Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab0KJAXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:23:34 -0500
Received: from kroah.org ([198.145.64.141]:55966 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0KJAXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:23:33 -0500
Date: Tue, 9 Nov 2010 16:19:57 -0800
From: Greg KH <greg@kroah.com>
To: Konstantin Katuev <katuev@dvbank.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging/keucr driver - uninitialized variable &
 proper memset length
Message-ID: <20101110001957.GA4111@kroah.com>
References: <AANLkTi=oFai7Mh_VmzeV1TanF-dfmGs=KWOgj+03V2iH@mail.gmail.com>
 <20101103144545.GA3665@kroah.com>
 <4CD23D28.20707@dvbank.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD23D28.20707@dvbank.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 02:57:12PM +1000, Konstantin Katuev wrote:
> Resent patch from another address because of formatting problems.

Sorry, it's still linewrapped and the spaces are all messed up.

can you try attaching it and I'll handle it that way?

thanks,

greg k-h
