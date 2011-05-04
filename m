Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1EDDtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 23:49:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51659 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1EDDtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 23:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tjk2KG8oau9hFXbch8VXfjNrfab8tO2E2Zzm7QuUrKk27Gc29rPFKtTbFleAOFkt+z
         ikIpgzUeFkcQhq3O2U9bNAYwchyAhW5KTBpw+qqFbTer+19TVi/m6hs6vhZyDTfyF7AA
         UfAx33MptIvEVgjrBbykWIhor6+kRFV4kRuUE=
MIME-Version: 1.0
In-Reply-To: <20110502004928.2307.25274.stgit@ul30vt.home>
References: <20110502004806.2307.34136.stgit@ul30vt.home>
	<20110502004928.2307.25274.stgit@ul30vt.home>
Date: Wed, 4 May 2011 13:49:03 +1000
Message-ID: <BANLkTi=ir8o0hxhv6EzJTMTJfgynpiUm9w@mail.gmail.com>
Subject: Re: [PATCH 1/2] vga_switcheroo: Remove unbalanced pci_enable_device
From: Dave Airlie <airlied@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is unbalanced and probably more fitting for the client
> to take care of.  Remove it.

I've queued this in -next.

Dave.
