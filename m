Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab2JWUuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:50:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56227 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab2JWUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:50:51 -0400
Message-ID: <50870328.7080800@gmail.com>
Date: Tue, 23 Oct 2012 15:50:48 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Josh Cartwright <josh.cartwright@ni.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 0/4] zynq subarch cleanups
References: <20121022211040.GA31538@beefymiracle.amer.corp.natinst.com> <201210231441.29107.arnd@arndb.de>
In-Reply-To: <201210231441.29107.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 09:41 AM, Arnd Bergmann wrote:
> On Monday 22 October 2012, Josh Cartwright wrote:
>> Hey all-
>>
>> Things have been relatively quiet on the Zynq front lately.  This
>> patchset does a bit of cleanup of the Zynq subarchitecture.  It was the
>> necessary set of things I had to do to get a zynq target booting with
>> the upstream qemu model.  It removes some unused clock infrastructure,
>> adds DT support for the GIC, and moves around peripheral mappings.
> 
> Ok, thanks for these patches. As we have moved on for some of these issues,
> I'll comment on how to go even further. On a global scale, I wonder
> if there are any obstacles for enabling CONFIG_MULTIPLATFORM on Zynq
> as we have done for most of the other recently added platform.

IIRC, the only thing I saw preventing it was the custom clk usage.

Rob

