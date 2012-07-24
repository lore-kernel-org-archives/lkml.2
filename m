Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2GXQyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:54:07 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:57979 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2GXQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:54:06 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGiC0Ifg==
X-RZG-CLASS-ID: mo00
Date: Tue, 24 Jul 2012 18:53:59 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, apw@canonical.com,
        netdev@vger.kernel.org, ben@decadent.org.uk
Subject: Re: [PATCH 10/17] Tools: hv: Gather ipv[4,6] gateway information
Message-ID: <20120724165359.GA8409@aepfle.de>
References: <1343145672-3641-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-1-git-send-email-kys@microsoft.com>
 <1343145701-3691-10-git-send-email-kys@microsoft.com>
 <20120724092914.60f3d90a@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120724092914.60f3d90a@nehalam.linuxnetplumber.net>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, Stephen Hemminger wrote:

> On Tue, 24 Jul 2012 09:01:34 -0700
> "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> 
> > +	memset(cmd, 0, sizeof(cmd));
> > +	strcat(cmd, "/sbin/ip -f inet  route | grep -w ");
> > +	strcat(cmd, if_name);
> > +	strcat(cmd, " | awk '/default/ {print $3 }'");
> 
> 
> Much simpler method:
> 
> ip route show match 0/0

This also has the benefit that ip is not called with absolute path, now
that distros move binaries around.

Olaf
