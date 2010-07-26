Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0GZWvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:51:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35408 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab0GZWvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100726.154854.35052662.davem@davemloft.net>
References: <20100726220405.1550.63442.stgit@angua> <20100726222627.GA23501@merkur.ravnborg.org> 
	<AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com> 
	<20100726.154854.35052662.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Jul 2010 16:51:01 -0600
X-Google-Sender-Auth: XLyuEkxXY7-3fLGNpzyZIB671nk
Message-ID: <AANLkTikpON7WUkTLrnW4y2kghM=H8cLCAFst08S3cL_Z@mail.gmail.com>
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default 
	of_node_to_nid()
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, sfr@canb.auug.org.au, monstr@monstr.eu,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 4:48 PM, David Miller <davem@davemloft.net> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Mon, 26 Jul 2010 16:42:20 -0600
>
>> It protects against some later include file doing a #define
>> of_node_to_nid and thus resulting in an inconsistent definition.  If
>> some code tries to do this then the preprocessor will complain.  This
>> is the pattern that Stephen suggested.
>
> Also, it would be nice to unravel the "0" vs. "-1" default
> inconsistency.

Indeed.  I looked at it briefly, but it wasn't immediately clear what
the impact would be to switch powerpc over to -1, and it looked to me
like sparc depends on -1 to signify no node association.

g.
