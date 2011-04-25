Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab1DYUmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:42:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34731 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab1DYUmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:42:46 -0400
Date: Mon, 25 Apr 2011 22:42:39 +0200
From: Willy Tarreau <w@1wt.eu>
To: Olaf Hering <olaf@aepfle.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Dmitry Torokhov <dtor@mail.ru>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 112/173] Input: xen-kbdfront - advertise either absolute or relative coordinates
Message-ID: <20110425204239.GB7646@1wt.eu>
References: <46075c3a3ef08be6d70339617d6afc98@local> <20110425200237.859884245@pcw.home.local> <20110425203158.GA8427@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425203158.GA8427@aepfle.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:31:58PM +0200, Olaf Hering wrote:
> On Mon, Apr 25, Willy Tarreau wrote:
> 
> > 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.
> 
> These two hunks have to be removed from the patch.
> If the guest is suspended/resumed the guest has to renegotiate with the
> new qemu-dm process and set the request-abs-pointer property again.

Done, thank you Olaf for the explanation.

Willy

