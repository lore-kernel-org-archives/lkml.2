Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab1CRWOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:14:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43740
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932338Ab1CRWOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:14:31 -0400
Date: Fri, 18 Mar 2011 15:15:09 -0700 (PDT)
Message-Id: <20110318.151509.241430327.davem@davemloft.net>
To: oakad@yahoo.com
Cc: linux-kernel@vger.kernel.org, galak@kernel.crashing.org,
        cbouatmailru@gmail.com, mlcreech@gmail.com,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] gianfar: Fall back to software tcp/udp checksum on
 older controllers
From: David Miller <davem@davemloft.net>
In-Reply-To: <598461.73809.qm@web37603.mail.mud.yahoo.com>
References: <598461.73809.qm@web37603.mail.mud.yahoo.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>
Date: Wed, 16 Mar 2011 20:57:13 -0700 (PDT)

> As specified by errata eTSEC49 of MPC8548 and errata eTSEC12 of MPC83xx,
> older revisions of gianfar controllers will be unable to calculate a TCP/UDP
> packet checksum for some alignments of the appropriate FCB. This patch checks
> for FCB alignment on such controllers and falls back to software checksumming
> if the alignment is known to be bad.
> 
> Signed-off-by: Alex Dubov <oakad@yahoo.com>

Applied.
