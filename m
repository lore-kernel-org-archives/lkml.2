Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0K3PO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:14:56 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:39017 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225Ab0K3POz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:14:55 -0500
Date: Tue, 30 Nov 2010 10:14:39 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc4
Message-ID: <20101130151439.GA2770@elliptictech.com>
References: <AANLkTikbjZXMio0CZ_AYGpi_8784EyWStK9sD23jSZzD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikbjZXMio0CZ_AYGpi_8784EyWStK9sD23jSZzD@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-29 21:36 -0800, Linus Torvalds wrote:
> The most _noticeable_ change is that hopefully the NFS readdir
> regression really got fixed now.

I'm still having readdir troubles with -rc4 where directories suddenly
show up completely empty.  For details and the test case (that still
reproduces it), see

  http://permalink.gmane.org/gmane.linux.nfs/36540

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
