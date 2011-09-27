Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1I0LVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:21:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53064 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab1I0LVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:21:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110926234835.GA9551@xanatos>
References: <20110912171003.GA7939@xanatos>
	<20110922183201.GA4659@xanatos>
	<201109251653.04170.rjw@sisk.pl>
	<201109270020.26439.rjw@sisk.pl>
	<20110926234835.GA9551@xanatos>
Date: Tue, 27 Sep 2011 19:21:41 +0800
Message-ID: <CAJRGBZxTakHn-BQTrLXsccriGAOERDox0pORMP+vrazzqAA-kQ@mail.gmail.com>
Subject: Re: PME via interrupt or SCI mechanism?
From: Luming Yu <luming.yu@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        robert.moore@intel.com, Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 7:48 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
>
> Ok.  Do you have suggestions for any tests I can run or debugging
> statements to add?  I'm really not an ACPI expert and I've been
> basically fumbling in the dark.

The following patch from Shaohua might be useful to help debugging the problem.
http://kerneltrap.org/mailarchive/linux-usb/2009/7/30/6251245

/l
