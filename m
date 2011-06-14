Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1FNFXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:23:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1FNFX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:23:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=MCTmPVs0KaMgoSnscdw5FDw51GabrQj1pp09jFbnSxcWEa/F5O0UgWypVZT9eIXLpN
         CBY3eJEdfyS++/DAOje+Zhz8qcvfrN7vd/RVb4ABxfdLFUNlJuo8UZafaLLt/SMVP8uC
         b77FFjwx1H2TIV82PXpRvohEdoDYUo2USW80g=
MIME-Version: 1.0
In-Reply-To: <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
References: <cover.1308024069.git.joe@perches.com> <337c22b774ff7f007b90b266b25c9a33ff555c48.1308024069.git.joe@perches.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 14 Jun 2011 15:23:07 +1000
Message-ID: <BANLkTi=i30Rn7gpCDbn9KKJucq8CB=hssA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] wireless: Remove casts of void *
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Jouni Malinen <jmalinen@atheros.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

On Tue, Jun 14, 2011 at 14:02, Joe Perches <joe@perches.com> wrote:
> Unnecessary casts of void * clutter the code.
>
> These are the remainder casts after several specific
> patches to remove netdev_priv and dev_priv.

You seem to have removed a lot of casts that don't relate to these cleanups.

In particular, some of the casts seem to relate more to documentation
rather than just changing pointer types to make the compiler happy. In
particular, I'm referring to the casts describing the different usages
of data_buf in mwiflex, and around some pointer math in ath9k.

Whilst I'm sure that the compiler is smart enough to handle automatic
casts between pointer types, some of these, in particular the mwiflex
bits, add some documentation to the code.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
