Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2KID7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:59:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45661 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2KID7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:59:44 -0500
MIME-Version: 1.0
In-Reply-To: <C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
References: <201211081915083774239@gmail.com>
	<509B962C.6070002@gmail.com>
	<C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
Date: Fri, 9 Nov 2012 11:59:42 +0800
Message-ID: <CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources for SR-IOV)
From: Jason Gao <pkill.2012@gmail.com>
To: "Rose, Gregory V" <gregory.v.rose@intel.com>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The BIOS in your machine doesn't support SR-IOV.  You'll need to ask the manufacturer for a BIOS upgrade, if in fact one is available.  Sometimes they're not.

very thanks Greg,my server Dell R710 with latest BIOS version and
option for SR-IOV(SR-IOV Global Enable->Enabled)  opened,I'm confused
that Does R710 provide full support for SR-IOV, kernel or  ixgbe
driver's bug? but I'm not sure where the problem lies,anyone has any
experience about this?   .
