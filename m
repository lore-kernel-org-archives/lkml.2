Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0KVRZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:25:20 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:44648 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab0KVRZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:25:19 -0500
Date: Mon, 22 Nov 2010 12:24:50 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.37-rc2-git4: Reported regressions from 2.6.36
Message-ID: <20101122172450.GA3010@elliptictech.com>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-19 00:23 +0100, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.36,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 2.6.36, please let us
> know either and we'll add them to the list.

The issue described in the following mail is still present in
2.6.37-rc3:

Re: [regression] NFS readdir change break fully cached nfs root

  http://permalink.gmane.org/gmane.linux.nfs/36540

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
