Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab2FMIi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:38:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47043 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2FMIiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:38:25 -0400
Message-ID: <1339576681.31548.116.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Wed, 13 Jun 2012 10:38:01 +0200
In-Reply-To: <4FD7AD6F.6010008@zytor.com>
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>
	 <20120612190720.GA11137@aftab.osrc.amd.com>
	 <1339529614.31548.104.camel@twins>
	 <20120612194900.GC11137@aftab.osrc.amd.com> <4FD7A687.3040500@zytor.com>
	 <20120612203730.GE11137@aftab.osrc.amd.com> <4FD7A99F.8030007@zytor.com>
	 <20120612205609.GF11137@aftab.osrc.amd.com> <4FD7AD6F.6010008@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 13:58 -0700, H. Peter Anvin wrote:
>  even things like Nehalem + Westmere in the same system

Uhm,.. how well do you expect Linux to run on a franken-system like
that? I'm pretty sure perf will malfunction in such a setup.
