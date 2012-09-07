Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab2IGWsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:48:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52036 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2IGWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <504A78E9.4030005@lwfinger.net>
References: <504A78E9.4030005@lwfinger.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Sep 2012 15:48:15 -0700
Message-ID: <CAErSpo7GEkN1XLZ=UeXmDZrLnp_648mH-sLYa9hMgOqz7t+b7Q@mail.gmail.com>
Subject: Re: Question about failure in PCI power-state change
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        =?GB2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+cc Rafael, Huang, linux-pm

On Fri, Sep 7, 2012 at 3:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hi,
>
> On occasion when I unload and reload driver rtl8192ce, I get the message
>
> "Refused to change power state, currently in D3"
>
> I added additional info to the printk and discovered that it was trying to
> change to state D0. The problem seems to occur when I have made a
> connection, unloaded the driver, and reloaded it. If I do not make a
> connection before unloading, then the problem is a lot less likely.
>
> This is with kernel 3.6-rc4 from wireless-testing. A Google search shows
> that the problem is usually due to suspend/resume difficulties, but this
> machine has not been suspended.
>
> I would appreciate any help that you might give in solving this issue.
>
> Thanks,
>
> Larry
