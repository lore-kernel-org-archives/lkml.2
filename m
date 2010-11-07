Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0KGUtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:49:50 -0500
Received: from home.kolivas.org ([59.167.196.135]:45773 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab0KGUtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:49:49 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux kernel compression with lrzip
Date: Mon, 8 Nov 2010 07:49:46 +1100
User-Agent: KMail/1.13.5 (Linux/2.6.35.7-ck1; KDE/4.4.5; x86_64; ; )
References: <201011072259.25625.kernel@kolivas.org> <4CD6BAEC.2070605@gmail.com>
In-Reply-To: <4CD6BAEC.2070605@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011080749.46824.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 01:42:52 Alexander E. Patrakov wrote:
> 07.11.2010 16:59, Con Kolivas wrote:
> > Lrzip
> > was a project I began based on rzip which tried to extend the initial
> > compression window beyond 900MB and to use lzma as the back end for the
> > 2nd stage compression.
> 
> <snip>
> 
> > Starting with linux kernel 2.6.36
> > 
> > 413511680 linux-2.6.36.tar
> > 70277083 linux-2.6.36.tar.bz2
> > 59905365 linux-2.6.36.tar.lrz
> 
> So, why are you comparing to tar.bz2, if you use lzma as the backend?
> I.e. this benchmark does nothing to show the benefit from the
> preprocessing stage. Please compare to tar.lzma instead.

It smoked the opposition so there was no need, and this was about the bigger 
files not the one tree.

There's a busload of benchmarks linked. 

http://ck.kolivas.org/apps/lrzip/README.benchmarks

Con

-- 
-ck
