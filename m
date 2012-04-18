Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2DRBFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:05:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:58110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2DRBFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:05:22 -0400
Message-ID: <1334711117.4785.43.camel@smoke>
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20120406
 release(hotcode analyzer hotcode.py can output html) include patch for
 review
From: Geoff Levand <geoff@infradead.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, zen lin <zen@openhuawei.org>
Date: Tue, 17 Apr 2012 18:05:17 -0700
In-Reply-To: <CANFwon0C46UWTLVSeBTTm_aUCub7qW9d+jm=71h894bRODwyQA@mail.gmail.com>
References: <CANFwon0C46UWTLVSeBTTm_aUCub7qW9d+jm=71h894bRODwyQA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hui,

On Sat, 2012-04-07 at 20:21 +0800, Hui Zhu wrote:
> Signed-off-by: Hui Zhu <teawater@gmail.com>

You have done some interesting work, but can I recommend a
few things?

Please break your patch into a few smaller ones, say, one
that adds the core kgtp support, one that adds the
documentation files, one that adds the scripts.  Each patch
should have a suitable comment that describes the
changes.  For kgtp the patch for the core support would
of course have a discussion of the feature and its
benefits, etc.

Also, please post your patches inline so we can give
line-by-line comments.  It is difficult to give comments
when the patch is an email attachment.

-Geoff


