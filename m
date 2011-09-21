Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1IURza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:55:30 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3116 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab1IURz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:55:29 -0400
Message-ID: <4E7A25AA.6000303@hetnet.nl>
Date: Wed, 21 Sep 2011 19:58:02 +0200
From: Henk de Groot <henk.de.groot@hetnet.nl>
Reply-To: henk.de.groot@hetnet.nl
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Dave Kilroy <kilroyd@googlemail.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: wlags49_h2: Declare support for WEXT 21
References: <1316462896-17846-1-git-send-email-kilroyd@googlemail.com> <1316462896-17846-4-git-send-email-kilroyd@googlemail.com> <15411.1316463771@turing-police.cc.vt.edu> <4E77A9B1.1040107@gmail.com> <20110920195205.GA27739@kroah.com> <4E78F47B.7000906@hetnet.nl> <20110920210233.GB9447@kroah.com>
In-Reply-To: <20110920210233.GB9447@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2011 17:55:27.0193 (UTC) FILETIME=[A50D4490:01CC7887]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 20-9-2011 23:02, Greg KH schreef:
> So, should I apply this patch or not?
>
> confused,
>
> greg k-h

It doesn't break anything and is was there to make sure the previous 
patches work, so yes, why not.

Henk.
