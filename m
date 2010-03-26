Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0CZVSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:18:46 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64446 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0CZVSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:18:45 -0400
MIME-Version: 1.0
In-Reply-To: <1268843158-15223-1-git-send-email-steve@digidescorp.com>
References: <1268843158-15223-1-git-send-email-steve@digidescorp.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Mar 2010 15:18:24 -0600
X-Google-Sender-Auth: d03c98a483a84b65
Message-ID: <fa686aa41003261418w4e28ed03m9ae3d87696e88af0@mail.gmail.com>
Subject: Re: [PATCH 0/4] dmaengine: Add driver for Xilinx MPMC
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 10:25 AM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> This is a DMA engine driver for SDMA channels on a Xilinx Multi-Port
> Memory Controller (MPMC).
>
> Caveats:
> * The OF bus driver (part 4) is based on the fsldma driver and how I
>  thought the device and channels might be represented in a device tree blob.
>  As I don't use OF in my kernel, all I am able to do is verify that the code
>  compiles. Suggestions for improvement are especially welcome here.

If you're not using the OF bits, then don't worry about them yet.
They can be added later.  of_platform is getting merged with platform
bus anyway, so one driver will work with both.

> * Similarly, I took a stab at DCR support based on the ll_temac driver
>  and some discussions about supporting both DCR and simple pointer access
>  to device registers. I'm working on Microblaze so cannot test the DCR code.

Again, don't bother with stuff you don't have.  It can be added after the fact.

g.
