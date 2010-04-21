Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0DUFHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:07:53 -0400
Received: from 1wt.eu ([62.212.114.60]:63458 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab0DUFHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:07:52 -0400
Date: Wed, 21 Apr 2010 07:07:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: Viswanathan Murugesan <viswa.murugesan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question on 2.6.25 kernel crash.
Message-ID: <20100421050749.GC7798@1wt.eu>
References: <j2pfe58d3641004201748uadddaf12n1cfec0c0bb98117c@mail.gmail.com> <n2pfe58d3641004201821r3805616id4a8cd5cdb745b46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n2pfe58d3641004201821r3805616id4a8cd5cdb745b46@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:21:08PM -0700, Viswanathan Murugesan wrote:
> 2.6.25 Kernel crashes when tried to upload a 2 MB file through FTP to
> a ftp server under a ipsec gateway.

Your logs are showing 2.6.25.7, which is two years old and not up to
date at all. 2.6.25 is not maintained anymore, but at least you should
have updated to 2.6.25.20 at that time. You basically missed 13 updates
on this version, so it is possible that your problem was identified and
fixed. Anyway, since it's not maintained anymore, you should probably
retry with 2.6.32.X which is going to be maintained for a long time.

Willy

