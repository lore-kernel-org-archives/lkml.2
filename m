Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1G1Xe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:34:26 -0400
Received: from mail.vyatta.com ([76.74.103.46]:59226 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170Ab1G1XeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:34:24 -0400
Date: Thu, 28 Jul 2011 16:34:34 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        drivers_network@kernel-bugs.osdl.org
Subject: Re: Add support for D-Link 530T rev C1 (Kernel Bug 38862)
Message-ID: <20110728163434.4d3bb048@nehalam.ftrdhcpuser.net>
In-Reply-To: <20110728231811.GH8562@caffeine.csclub.uwaterloo.ca>
References: <20110728231811.GH8562@caffeine.csclub.uwaterloo.ca>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011 19:18:11 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> The D-Link DGE-530T rev C1 is a re-badged Realtek 8169 named DLG10028C,
> unlike the previous revisions which were skge based.  It is probably
> the same as the discontinued DGE-528T (0x4300) other than the PCI ID.
> 
> The PCI ID is 0x1186:0x4302.
> 
> Adding it to r8169.c where 0x1186:0x4300 is already found makes the card
> be detected and work.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=38862
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

Glad they at least changed the PCI-ID this time.
Other vendors have been known to do it wrong.
