Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935Ab2DLWJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:09:08 -0400
Received: from solo.fdn.fr ([80.67.169.19]:37475 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2DLWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:09:06 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 18:09:06 EDT
Date: Fri, 13 Apr 2012 00:00:48 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@suse.de>,
        Alan Cox <alan@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: tty, hvc, xen: leak? dead code? everything is fine?
Message-ID: <20120412220048.GM4245@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@suse.de>, Alan Cox <alan@linux.intel.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <alpine.LNX.2.00.1204122318480.7553@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1204122318480.7553@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl, le Thu 12 Apr 2012 23:33:20 +0200, a écrit :
> Or *if* there's actually no way 'info->intfw' can actually be anything but 
> NULL in this case,

There is no way that it's both non-NULL and the if was entered above: if
the if was entered, the content of info is zeroes (kzalloc).

Samuel
