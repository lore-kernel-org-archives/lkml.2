Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0CYBn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:43:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587Ab0CYBnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:43:24 -0400
Date: Wed, 24 Mar 2010 18:42:26 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-23 - IPv6 warnings...
Message-Id: <20100324184226.3bf42d8f.akpm@linux-foundation.org>
In-Reply-To: <12096.1269481001@localhost>
References: <201003232301.o2NN1bms031050@imap1.linux-foundation.org>
	<12096.1269481001@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 21:36:41 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 23 Mar 2010 15:34:59 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-03-23-15-34 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Seen in my dmesg.  It may be relevant that I'm at home, and my IPv6
> prefix arrives via a PPP VPN connection. This happened about 20-25 seconds
> after I launched pppd.

Yes, thanks, I get the same - it doesn't seem to break anything.  It
also happens some time after boot has completed, presumably when I do
something, but I haven't looked into what "something" is.  It's
certainly not as complex as a PPP VPN connection.

The net guys are crunching on it.
