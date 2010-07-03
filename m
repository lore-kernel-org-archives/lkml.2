Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0GCAUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 20:20:18 -0400
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:39971 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0GCAUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 20:20:16 -0400
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kyle D Moffett <kyle@moffetthome.net>
Date: Fri, 2 Jul 2010 19:20:07 -0500
Subject: Re: [P2020] "Processor 1 is stuck" (introduced by 8b27f0b61)
Thread-Topic: [P2020] "Processor 1 is stuck" (introduced by 8b27f0b61)
Thread-Index: AcsaRX9kRcZ6arWIRC+pJwoAETuQgA==
Message-ID: <1351736A-3DD7-4BE1-BF60-D95DFFEBA718@boeing.com>
References: <BAD2EBFA-91F7-478B-8BA8-F7A099050A2F@boeing.com>
In-Reply-To: <BAD2EBFA-91F7-478B-8BA8-F7A099050A2F@boeing.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 02, 2010, at 19:30, Moffett, Kyle D wrote:
> I'm working on a new board port to a P2020-based system (e500v2) and I appear to be hitting a regression which causes the second core to fail to come up at boot with a "Processor 1 is stuck" message.
> 
> [...]
> 
> If I revert 8b27f0b61 on top of v2.6.34 (I fixed the conflicts by deleting the extra hunks), both CPUs come up properly.  My current board support files can be browsed via gitweb or cloned via smart-http or natively from here:
>  http://opensource.exmeritus.com/git/hww-1u-1a/linux.git
>  git://opensource.exmeritus.com/hww-1u-1a/linux.git

With a little bit more debugging, I was able to strip the patch down to a partial revert (on top of v2.6.34) which seems to fix the bug here.  I pushed that patch out to the "latest-v2.6.34" branch of linux.git as commit 1214341.

Cheers,
Kyle Moffett