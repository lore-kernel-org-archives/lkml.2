Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650Ab2BNOEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:04:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38779 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab2BNOEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:04:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120213163546.GA31316@redhat.com>
References: <CPSMTPM-CMT109lZGdO0011ecc5@CPSMTPM-CMT109.kpnxchange.com>
 <20120213162852.GA29947@redhat.com> <20120213163546.GA31316@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 14 Feb 2012 15:03:45 +0100
Message-ID: <CAPXgP13bmNdd2BufiRxhCJEAoQ6bvh6=UT=tUpXCg+07gLn+1Q@mail.gmail.com>
Subject: Re: Cpufreq shutdown patch (kernel 2.6.35.3)
To: Dave Jones <davej@redhat.com>, "N. Coesel" <nico@nctdev.nl>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 17:35, Dave Jones <davej@redhat.com> wrote:
> On Mon, Feb 13, 2012 at 11:28:53AM -0500, Dave Jones wrote:

> Except I can't of course, because we no longer have a sysdev driver
> since 8a25a2fd126c621f44f3aeaef80d51f00fc11639
> Kay, given the subsys_interface doesn't have a shutdown method, what should
> this be doing ?

The former sysdev device's power management methods have been split
off to a separate 'struct syscore_ops' and all users converted to it,
to be able to remove the sysdev stuff.

Kay
