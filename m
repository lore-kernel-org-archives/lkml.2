Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab1DTTXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:23:38 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52685 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1DTTXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <4DAEF98D.2090802@ladisch.de>
References: <16117.1303310442@jupiter.eclipse.co.uk>
	<4DAEF98D.2090802@ladisch.de>
Date: Wed, 20 Apr 2011 14:23:36 -0500
Message-ID: <BANLkTimO_9UQvCPKGKYM+AeL0dwC_8CzOw@mail.gmail.com>
Subject: Re: Background memory scrubbing
From: Bill Gatliff <bgat@billgatliff.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: rwhitton@iee.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ladisch:


On Wed, Apr 20, 2011 at 10:19 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Which hardware platform is this?  AFAICT all architectures with ECC
> (old AMD64, Family 0Fh, Family 10h) also have scrubbing support.
> If your BIOS is too dumb, just try enabling it directly (bits 0-4 of
> PCI configuration register 0x58 in function 3 of the CPU's northbridge
> device, see the BIOS and Kernel's Developer's Guide for details).

That won't help non-AMD64 platforms that want to scrub.

Is there a way to make Robert's approach work?  I'm aware of a few
non-AMD64, somewhat-exotic platforms that require scrubbing the way
that Robert is proposing...


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
