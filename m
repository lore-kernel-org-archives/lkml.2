Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1H3TGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:06:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49688 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125Ab1H3TGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:06:41 -0400
X-Sasl-enc: ZZ28DjXAS7sIYY2bhRBdG7mTajRymPcnxRhvW3MuZL8t 1314731200
Date: Tue, 30 Aug 2011 12:06:29 -0700
From: Greg KH <greg@kroah.com>
To: Vishnupradeep <intermedia.vishnu@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [stable] linux-3.0.4 compile error on file
 arch/x86/include/asm/unistd_64.h
Message-ID: <20110830190629.GA5638@kroah.com>
References: <CACk0-C9jZatg+v=7DPJtkp3G1k_eiZbwSPDAgqabMyedmKd9YA@mail.gmail.com>
 <4E5C8EA3.7060304@gmail.com>
 <CACk0-C8E2uaB-Ben5K0e7dzC9RC_WDoXx8mV4B-PN4LPYGs92g@mail.gmail.com>
 <20110830181639.GB24865@kroah.com>
 <CACk0-C-zwNOJOY0t7_vQqVBJR9TzKehv+0GTvHxuDiOtSvV0qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACk0-C-zwNOJOY0t7_vQqVBJR9TzKehv+0GTvHxuDiOtSvV0qA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Aug 31, 2011 at 12:18:56AM +0530, Vishnupradeep wrote:
> i configured it using "make menuconfig"
> 
> .config File attached

Can you try downloading the tarball and trying again, Jiri's "bit
flipped" comment makes a lot of sense here.

thanks,

greg k-h
