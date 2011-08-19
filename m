Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1HSPNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:13:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62538 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1HSPNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:13:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110727153808.GA16180@tassilo.jf.intel.com>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
	<m1r5n7ln0l.fsf@fess.ebiederm.org>
	<CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
	<20110726194956.GA4117@tassilo.jf.intel.com>
	<CAKdQVUZgSJi4z1BnwnKiOjX7L2dhOyMxA018sS-MtqOQixSKeg@mail.gmail.com>
	<20110727153808.GA16180@tassilo.jf.intel.com>
Date: Fri, 19 Aug 2011 23:13:46 +0800
Message-ID: <CAKdQVUbmMca+iV6yzrBy0Rcuw6YQn3pMin3+_iQC4=vg_bMtPA@mail.gmail.com>
Subject: Re: x86_64 virtual memory map
From: Bob Zhang <zhanglinbao@gmail.com>
To: Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in fact , there are two factors to affect how much DRAM final user can use .

for example , for HP's this kind of machine , BIOS can support 40-bit
size and 44 -bit size.
if in BIOS ,user select 44-bit size , then every CPU(socket) can
support 512GB , if user install 8 CPU(socket) , it totally support
4TB.
if in BIOS ,user select 40-bit size , then every CPU(socket) only can
support 128GB , so if user install 8s(socket) , it totally only can
support 1TB, if 4s, only support totally 512GB.

certainly ,this is also decided by OS support 44-bit size or not. if
OS,i.e. rhel5.x  , only support 40bit ,though BIOS 44-bit selected ,
only 40-bit size support every CPU(socket).
