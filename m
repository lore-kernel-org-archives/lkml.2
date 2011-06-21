Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1FUOWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:22:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26814 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab1FUOWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:22:01 -0400
Date: Tue, 21 Jun 2011 10:18:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/7] x86: convert ticketlocks to C and remove
 duplicate code
Message-ID: <20110621141853.GA15252@dumpdata.com>
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E00A85E.010E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 02:40:47PM -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Hi all,
> 
> I'm proposing this series for 3[.0].1.

Is there a git branch with these patches? I've looked over them
and they look good (and they make the code much easier to read)
but I would like to ingest them in my branches for some extra
testing goodness.
