Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0EZURs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:17:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19871 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0EZURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:17:47 -0400
Date: Wed, 26 May 2010 13:17:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kbuild: menuconfig with O=<dir> creates empty include/config in
 base
Message-Id: <20100526131725.49bd41cd.randy.dunlap@oracle.com>
In-Reply-To: <20100526065611.GD4720@trinity.fluff.org>
References: <20100526065611.GD4720@trinity.fluff.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BFD81DF.015C:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 07:56:11 +0100 Ben Dooks wrote:

> When doing "make O=test menuconfig" the base kernel directory picks up
> a new empty directory include/config which stops further "make O=temp"
> builds as the make system thinks the base directory is not clean.
> 
> I've had a look, but it is not easy to see where this is hapening.
> 
> So far only menuconfig seems to have triggered it, xconfig seems to work.


I cannot reproduce this problem.  Can you provide more complete steps
to make it happen?

I've had similar problems occasionally but I haven't been able to track
them down...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
