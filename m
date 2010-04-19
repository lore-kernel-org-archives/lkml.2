Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0DSVqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:46:12 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:56520 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0DSVqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:46:11 -0400
Date: Mon, 19 Apr 2010 14:46:10 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [2.6.34 regression] utsname.domainname not set in x86_32
	processes
Message-ID: <20100419214610.GA26636@hexapodia.org>
References: <20100419192147.GP11130@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419192147.GP11130@hexapodia.org>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 12:21:47PM -0700, Andy Isaacson wrote:
> 2.6.34-rc4 uname(2) from a x86_32 process copies out 325 bytes rather
> than the 390 bytes that 2.6.31 copied out (and that userland expects):

I've verified that this works correctly on 2.6.33, and opened
https://bugzilla.kernel.org/show_bug.cgi?id=15812

Note that this manifests as the following error when a x86_32 process
attempts to use libnss_nis:

YPBINDPROC_DOMAIN: Domain not bound

-andy
