Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2CJGpW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 01:45:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64224 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2CJGpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 01:45:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
References: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
Date: Sat, 10 Mar 2012 06:45:15 +0000
Message-ID: <CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
Subject: Re: [advice sought] EOMA68 kernel support
From: lkcl luke <luke.leighton@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 9, 2012 at 10:41 PM, lkcl luke <luke.leighton@gmail.com> wrote:

> the implications of that split, for the linux kernel source code, are
> a bit... scarey :)

 ... so, real simple very basic, concrete and necessary question:
where the hell in the linux kernel tree should support for eoma68 be
added??

 * driver support can't be added to drivers/ because although a device
with an EOMA68 CPU card *requires* drivers, it's not *actual* drivers
being added, it's driver *grouping* code that's required, and that
concept simply does... not... exist.

 * architecture support can't be added to arch/ because that contains
code for CPUs not code that is about helping to support multiple CPUs.
 eoma isn't a CPU.

 * adding a top-level directory "eoma" is a bit too "whoa" but i
really don't see any suitable subdirectories.

so.

very basic question.  where the hell should EOMA support source code go?

bearing in mind that the first CPU card is an Allwinner A10, the next
one is likely to be an AMD Fusion, the one after that could be from
icubecorp, the one after that a multi-core SMP xtensa, etc.

l.
