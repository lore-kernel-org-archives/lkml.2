Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0ICCOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:14:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:40880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503Ab0ICCOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:14:31 -0400
Date: Thu, 2 Sep 2010 19:14:10 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: "Wang, Qi" <qi.wang@intel.com>, Greg KH <greg@kroah.com>,
        meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        arjan@linux.intel.com, alan@linux.intel.com,
        "Foster, Margie" <margie.foster@intel.com>,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100903021410.GA20766@suse.de>
References: <4C7E441E.4090006@dsn.okisemi.com>
 <20100902010236.GA21782@kroah.com>
 <000601cb4a47$b1a7d1d0$66f8800a@maildom.okisemi.com>
 <20100902032227.GA27463@suse.de>
 <D5AB6E638E5A3E4B8F4406B113A5A19A2A56E53B@shsmsx501.ccr.corp.intel.com>
 <002b01cb4a6a$3ae499c0$66f8800a@maildom.okisemi.com>
 <20100902131913.GB1021@suse.de>
 <001101cb4afe$0f729ff0$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101cb4afe$0f729ff0$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 09:22:12AM +0900, Masayuki Ohtake wrote:
> Hi Greg,
> 
> We are going to maintain our patch using kernel-tree's
> after merging kernel-tree.

The driver is now merged into the linux-next tree, so you should be
fine.  Please send any follow-on patches to me against that tree.

thanks,

greg k-h
