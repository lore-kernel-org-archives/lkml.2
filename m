Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab0HLDho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:37:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089Ab0HLDhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=hjB6OH2J294VTj/FIV4Rg/vyoTuZd8gVNEk0+kJGYgj9sa2rEGnv/DxY/vPMFMgo0U
         yspUWiVVH+4Y5s3o39W4SP/eafC7XZJ/eAkzU91oo2wnC4k3jqbhVe38HcJ09iyr+ni7
         DotbOOjZfQkqtiRw4f6Rdj3I25cESGn5Tm+o0=
MIME-Version: 1.0
In-Reply-To: <201008120457.25635.marek.vasut@gmail.com>
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com> 
	<201008120457.25635.marek.vasut@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 11 Aug 2010 23:37:21 -0400
Message-ID: <AANLkTik3MUVzbpuLN4HgyYRPG0D-sA-WCAaRYejyi10L@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] ARM: Fix gen_nand probe structures contents
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 22:57, Marek Vasut wrote:
> NOTE for bfin guys: I'm slightly concerned about overall code quality on the
> BFIN architecture.

that makes one of us
-mike
