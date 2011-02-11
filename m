Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1BKTcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab1BKTcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:32:10 -0500
Message-ID: <4D558EA7.2070707@redhat.com>
Date: Fri, 11 Feb 2011 20:31:51 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Felix Blanke <felixblanke@gmail.com>
CC: Chris Samuel <chris@csamuel.org>, kreijack@inwind.it,
        Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: LOOP_GET_STATUS(64) truncates pathnames to 64 chars (was Re:
 Bug in mkfs.btrfs?!)
References: <20110122144513.GA2539@scooter>	<20110122145222.GB2539@scooter>	<20110122151124.GC29985@carfax.org.uk>	<20110122155612.GA3664@scooter>	<20110123181827.GF29985@carfax.org.uk>	<4D3CA568.7050506@libero.it>	<20110124130104.GA7354@scooter>	<4D3E160F.4050006@csamuel.org>	<20110210122927.GB20488@foxbat.suse.cz>	<20110211130412.GA2591@scooter>	<4D55870C.8020805@redhat.com> <AANLkTi=Arg-09F0DXsWNhsYgyPar=rKs7G_OQG2uMm4f@mail.gmail.com>
In-Reply-To: <AANLkTi=Arg-09F0DXsWNhsYgyPar=rKs7G_OQG2uMm4f@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 08:23 PM, Felix Blanke wrote:
> What do you mean with "configured"?
> 
> I'm using loop devices with loop aes, and I've looked into /sys for a device which is actually in use.

Ehm. It is really Loop-AES?

Then ask author to backport it there, Loop-AES is not mainline code.
He usually replaces the whole upstream loop implementation with old patched version.

Milan
