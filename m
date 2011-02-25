Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab1BYOcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:32:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51207 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1BYOcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:32:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mvFIg7MwjukIcTrmKYiEUtwzqpiLlyImX+daWge04fdxchKH9A64ni+1BWOUcuOakF
         V0SRtQ5Iqs5/HtzsasRXzat7+WLYDotuJG9CqaWpaoujD+vBk9d+tpr8wAjzdZmGmbUk
         PkHeYi0y7poMgsNumkHhWk+/5DZrKjh/giVOs=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=2a=9=k+ZG46yqKOaHd9tCkJVm4QRxGmgbRzsv@mail.gmail.com>
References: <20110219150644.681D59D401D@zog.reactivated.net>
	<AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
	<AANLkTi=2a=9=k+ZG46yqKOaHd9tCkJVm4QRxGmgbRzsv@mail.gmail.com>
Date: Fri, 25 Feb 2011 14:32:04 +0000
X-Google-Sender-Auth: uU9DHOD6KRUe9uqge_YQPpb6BtU
Message-ID: <AANLkTimhoYYYC64ZkDp8=f5dAgLmK7B-9Jud9-n0e4S2@mail.gmail.com>
Subject: Re: [PATCH] olpc_battery: bind to device tree
From: Daniel Drake <dsd@laptop.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2011 14:19, Daniel Drake <dsd@laptop.org> wrote:
> /battery@0/compatible property added with value "olpc-battery" (XO-1 and XO-1.5)
> /pci/isa@f/rtc@i70/compatible property prepended with "olpc-xo1-rtc,"

That comma at the end should be dropped. I just realised that the
separator between different elements in the compatible list is a NULL
character.
