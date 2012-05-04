Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab2EDUuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:50:39 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:54035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760072Ab2EDUue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:50:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC v2 3/5] PCIe, Add runtime PM support to PCIe port
Date: Fri, 4 May 2012 22:55:13 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <1336119221-21146-4-git-send-email-ying.huang@intel.com> <CAErSpo59RkMo_=8E4ki+f99yDrep5ZjRY5J1CdLoMFws+n_XuQ@mail.gmail.com>
In-Reply-To: <CAErSpo59RkMo_=8E4ki+f99yDrep5ZjRY5J1CdLoMFws+n_XuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205042255.13508.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 04, 2012, Bjorn Helgaas wrote:
> On Fri, May 4, 2012 at 2:13 AM, Huang Ying <ying.huang@intel.com> wrote:
> > From: Zheng Yan <zheng.z.yan@intel.com>
> >
> > This patch adds runtime PM support to PCIe port.  This is needed by
> > PCIe D3cold support, where PCIe device in slot may be powered on/off
> > by PCIe port.
> 
> I assume this works for integrated PCIe devices as well as those that
> are plugged into a slot and can be physically removed -- maybe the
> text "in slot" is superfluous?
> 
> > Because runtime suspend is broken for some chipset, a white list is
> > used to enable runtime PM support for only chipset known to work.
> 
> A whitelist requires perpetual maintenance.  Every time a new working
> chipset comes out, you have to update the whitelist.  That doesn't
> seem right.

Well, we can't possibly enable the feature for all PCIe ports in existence
either, because some of them will not work with it (almost surely).

Thanks,
Rafael
