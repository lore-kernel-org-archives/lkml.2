Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381Ab1FWSpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:45:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64498 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab1FWSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KClu/6vuJczv5HIrEmJKGlgj06n6hy59Ze+dTY8KHW7DZFW2egMJ1LxQiYB5A0d+Ia
         jsVSJoJPnpWhUxNl+BWjr3PWOAGiS0is5zaj5qhiPhEtONv6QXCLm+x+jK3IrLv0uZPQ
         QCwADs5BM+pMF252+E07ssv//CmlSsNpAMguU=
Message-ID: <4E038869.7010005@gmail.com>
Date: Thu, 23 Jun 2011 20:39:37 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@chromium.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samo Pogacnik <samo_pogacnik@t-2.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char drivers: Ram oops kernel configuration parameters
References: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
In-Reply-To: <1308854160-16022-1-git-send-email-sergiu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 23/06/2011 20:36, Sergiu Iordache ha scritto:
> Ramoops currently has module parameters for setting the configuration
> variables (ram start, ram size and dump oopses). This makes it difficult to
> configure when the module is compiled as a builtin.
>

isn't it enough to set them via command line?

Marco
