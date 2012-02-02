Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab2BBVet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:34:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38403 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933266Ab2BBVeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:34:20 -0500
Message-ID: <1328218456.18641.60.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 13:34:16 -0800
In-Reply-To: <alpine.LNX.2.00.1202022225210.16813@swampdragon.chaosbits.net>
References: <20120202200621.GB9279@leaf>
	 <20120202202207.GA10041@elliptictech.com>
	 <alpine.LNX.2.00.1202022225210.16813@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 22:29 +0100, Jesper Juhl wrote:
> But generally a good idea to warn about "easily grepable strings broken 
> into multiple lines" if possible, IMHO...

Maybe count the %'s?  Ignore if more than 2?


