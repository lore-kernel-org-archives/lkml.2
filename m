Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab1AJRCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:02:12 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41578 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1AJRCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qpLXJn71Mw6pPvfDuzLX2GUGrRP7pqpvLzYerp5qQmsGIKG+zXx/BH1mlhI4l1WtTe
         mcqlvfhr/MRFAiugUkPjwp1e9yjlXCsZJ+VLwOOkJX6kzHEhrAcYzgc1Btz1TzM2pT6Q
         YJeMjsuXh9a5cUKnhdUtb2lazeeQZAdkNJtnw=
MIME-Version: 1.0
In-Reply-To: <20110110083024.ab3bad25.rdunlap@xenotime.net>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
	<201101101244.24932.christoph.paasch@uclouvain.be>
	<20110110075032.e38955ef.rdunlap@xenotime.net>
	<201101101724.46023.christoph.paasch@uclouvain.be>
	<20110110083024.ab3bad25.rdunlap@xenotime.net>
Date: Mon, 10 Jan 2011 19:02:06 +0200
Message-ID: <AANLkTim38gKQqrh=wKC+NRf=ypKus1t8mdtmGtW-3rKU@mail.gmail.com>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: christoph.paasch@uclouvain.be, Ben Hutchings <bhutchings@solarflare.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 6:30 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> If you just want to fix source files that are missing header files, then
> the patches should be accepted, even if they are not "needed" in some
> strong sense of that word.

This will create a lot of noise. As if we haven't seen enough before.
