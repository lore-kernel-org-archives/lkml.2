Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab0ERLxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 07:53:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50178 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab0ERLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 07:53:14 -0400
MIME-Version: 1.0
In-Reply-To: <20100518174750.cc965d84.sfr@canb.auug.org.au>
References: <20100518174750.cc965d84.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 18 May 2010 05:52:53 -0600
X-Google-Sender-Auth: 9BtSz2uhTRr-ELhNPcX3wPC0Ytw
Message-ID: <AANLkTil4MIKUrzK-SOS9satdcL34F5B_3D6ddFn6lThL@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree 
	(devicetree tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 1:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> After merging the final tree, yesterday's linux-next build (powerpc
> mpc85xx_defconfig) failed like this:
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/2615202/
>
> I suspect that is something to do with the devicetree tree.

Ah, yes.  I'll push out fixes for those this morning.

g.
