Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0CZDbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:31:13 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:53574 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab0CZDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:31:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=kIVNCaC3GLNqTx2hd3pRQEx73Qu1ix6mjhnUjTEZoQmJC2+kKiQ8ntHGOcaSv9znDh
         ROsoi+4rhQ1evs/tlIhBu8yol9mLPd+JzZ8blEhA2O540by80x3bKgi2Upx0ayFCbvvu
         uvHh0qSQd43xIf5xdgPVBGXzXWqSVS4gtx2CE=
Message-ID: <4bac2a7e.8278e70a.5fa7.1315@mx.google.com>
Date: Thu, 25 Mar 2010 20:31:10 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <20100317093704.GA17146@elte.hu>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317045350.GA2869@laptop> <20100317093704.GA17146@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 10:37:04 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> 
> A call-graph profile will show the precise reason for IO latencies, and their 
> relatively likelihood.
> 
Once I get home I'll try to reproduce the issue and get a call graph. Thanks!

- Ben
