Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0FILrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 07:47:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54469 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab0FILre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 07:47:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R31TXdyvZS88J77bTXoLhngS+5I9fakit8CrjqQzvTCcR2Rgk/IUFXtutjVYbhPeTE
         hjxIfkiC/TvimljDHFh+3DSr855Clwl8LHKXKp+tVryAfnspiDz3qTUD5lvN2hf2Ct1e
         EIM2KRfkBOMxMfUvI85o6QnX2YggbKTLGfUIM=
MIME-Version: 1.0
In-Reply-To: <e58860bae0d4571f3932df24fb6db0757bc260fe.1275925108.git.siccegge@cs.fau.de>
References: <cover.1275925108.git.siccegge@cs.fau.de>
	<e58860bae0d4571f3932df24fb6db0757bc260fe.1275925108.git.siccegge@cs.fau.de>
Date: Wed, 9 Jun 2010 13:47:33 +0200
Message-ID: <AANLkTind_RjQ5X2zR1fhTgKuLOU4Kbve3uQlgGMI559X@mail.gmail.com>
Subject: Re: [PATCH 6/9] Removing dead CONFIG_I2C_PNX0105
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 1:22 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
> CONFIG_I2C_PNX0105 doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

The code should probably just be adjusted to use the i2c-pnx driver.  According
to the comments it supports the pnx0105 i2c cell.

Manuel
