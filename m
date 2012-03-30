Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061Ab2C3RIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:08:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58009 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab2C3RHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:07:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MVYUQRpdDSef-hRzodB2Jtn-pKB0T-J2PB_XBed2WA9eg@mail.gmail.com>
References: <CACqU3MVYUQRpdDSef-hRzodB2Jtn-pKB0T-J2PB_XBed2WA9eg@mail.gmail.com>
Date: Fri, 30 Mar 2012 10:07:55 -0700
X-Google-Sender-Auth: CuJs94P4gz2KOLyHv0-cJ-JxyQE
Message-ID: <CA+8MBb+7jJq8KjGdaJHwed2u4=6XGs+cWxALVro9E5R1sZihWg@mail.gmail.com>
Subject: Re: MCE triggered with v3.1 and v3.2 on Xeon E5
From: Tony Luck <tony.luck@intel.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 9:15 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Currently, I would suspect an hardware issue as the machine is brand
> new. I'll see if v3.3 trigger the same MCE and eventually run a
> memtest.

Probably a bad DIMM (you have 4 corrected errors from addresses close
to each other - then an uncorrected error which causes the panic.

The DIMM is in socket 0, channel 3 ... but if you have more than one DIMM
in channel 3 you'll have to try each in turn to see which is causing the problem
(or compile and load drivers/edac/sb_edac.c to see if it gives you a
more precise
location).

-Tony
