Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0IJS7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:59:43 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:54413 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0IJS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:59:42 -0400
Date: Fri, 10 Sep 2010 11:59:42 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@kernel.org" <akpm@kernel.org>
Subject: Re: [PATCH RFC 1/1] MISC: Broadcom BCM4751 GPS driver
Message-ID: <20100910185942.GB17794@hexapodia.org>
References: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com> <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com> <1283512047.26985.119.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283512047.26985.119.camel@masi.mnp.nokia.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 02:07:27PM +0300, Matti J. Aaltonen wrote:
> On Mon, 2010-08-23 at 16:00 +0200, Aaltonen Matti.J (Nokia-MS/Tampere)
> wrote:
> > Driver for Broadcom BCM4751 GPS chip.
> 
> I sent this a while ago but didn't get any comments about the code. What
> do you think should something be changed or is it ready to get accepted?

It's unlikely to get merged if there's no public documentation of the
protocol it exposes, and no free codebase using the interface.

-andy
