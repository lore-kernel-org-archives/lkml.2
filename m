Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738Ab2HQIuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:50:00 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41054 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030960Ab2HQIod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:44:33 -0400
Message-ID: <502E046B.3030403@mev.co.uk>
Date: Fri, 17 Aug 2012 09:44:27 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120728 Thunderbird/14.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/35] staging: comedi: update comedi pci drivers
References: <201208161940.55761.hartleys@visionengravers.com>
In-Reply-To: <201208161940.55761.hartleys@visionengravers.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-08-17 03:40, H Hartley Sweeten wrote:
> Remove the manual legacy 'attach' callback in the comedi pci drivers
> that have it stubbed out. The 'attach' callback is not optional in
> the comedi core.

Just to avoid confusion, I think Hartley meant "now optional" in the 
above sentence!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
