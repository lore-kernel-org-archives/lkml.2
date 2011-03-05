Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1CEUFt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 15:05:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60542 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1CEUFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 15:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=JNGIShOXf+dTwSxhrC4PBd2S9LOjba+hXu3f9DOn81xtPcHkGIDgdKExIj6G3QoN1v
         tC+1kuUWNZefsaLjKTSXfKZN8AVJ51Y8aR1HWgdFEZC+WfEBTbhjX8ML2j8PEqoAZdtS
         u9IG01QOVlIc4IDV4V63vD6iaXNzdNYJlVhcY=
Date: Sat, 5 Mar 2011 21:05:37 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Philippe LeCavalier <support@plecavalier.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: Second drive on VT6421
Message-ID: <20110305210537.7675b600@varda>
In-Reply-To: <1299350988-sup-2113@plc.intranet.plecavalier.com>
References: <1299350988-sup-2113@plc.intranet.plecavalier.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 05 Mar 2011 14:00:44 -0500
Philippe LeCavalier <support@plecavalier.com> escribió:

 Adding linux-ide to CC

> I know it's been discussed but since it's been a while, has anyone
> managed to get a second drive detected with this card?
> 
> I'm on Deb Squeeze with 2.6.32-5
> 
> sata_via is loading fine and I can see the drives if they're connected
> individually but not if I connect both. If I do connect both I only see
> one of them -which is always from the same port-.
> 
> To be clear, I'm not referring to the eSATA port. I'm not up to that
> yet.
