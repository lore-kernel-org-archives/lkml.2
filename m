Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0D1CNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 22:13:39 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:54364 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0D1CNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 22:13:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=eLYXs2xF1FODX+On1G5jWLXuKJeQ5D4f/rLWLxeiH2aKkAIcLIbbDXCZWVdZOBXsjJ
         I3UhaTISlRFCwTI2dWH/3nssW5DBFFc88CUCrCp8PN2UZi4gVUdtpyc/vR07naGYSg6W
         R843cOZPbaOjS6Q55rJn7HO3fg/fgBjq6jwNg=
MIME-Version: 1.0
In-Reply-To: <20100428020819.GN12389@ozlabs.org>
References: <cover.1271427118.git.jbaron@redhat.com> <20100422.161700.191166551.davem@davemloft.net> 
	<20100427.175858.134109609.davem@davemloft.net> <20100428013951.GM12389@ozlabs.org> 
	<20100428014941.GA8389@Krystal> <20100428020819.GN12389@ozlabs.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 27 Apr 2010 22:13:17 -0400
Message-ID: <j2x8bd0f97a1004271913zedbeaf29td63419aab840dbb5@mail.gmail.com>
Subject: Re: [PATCH 00/11] jump label v7
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, dank@kegel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 22:08, Tony Breeds wrote:
> In terms of "testing", I build a kernel for each toolchain but I don't boot
> them and in the past I think blackfin said that what I had wouldn't actually be
> runable.

every Blackfin defconfig should be buildable & bootable

> Last time I looked the wasn't a non-intel cross-toolchain for blackfin.

we provide 32bit and 64bit binaries for people, and a simple script to
build up from source.  if you're looking for some other arch, you need
only ask.  it's easy for me to ppc/ppc64/ia64 (and ive done them in
the past), but no one has asked for those in a while.
-mike
