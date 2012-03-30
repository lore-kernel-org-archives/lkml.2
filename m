Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab2C3OTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:19:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64833 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759621Ab2C3OT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:19:26 -0400
Date: Fri, 30 Mar 2012 07:19:20 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Du, Alek" <alek.du@intel.com>, "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH v2] tty: hold lock across tty buffer finding and buffer
 filling
Message-ID: <20120330141920.GA17744@kroah.com>
References: <EE928378561BF1449699C96571234A740FCC5EC3@SHSMSX102.ccr.corp.intel.com>
 <20120316201445.GA1240@kroah.com>
 <EE928378561BF1449699C96571234A740FCCE410@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <EE928378561BF1449699C96571234A740FCCE410@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 10:26:27AM +0000, Tu, Xiaobing wrote:
> Hi Greg
>   Even there still a prepare buffer not protected, the patch is still
> good to protect rest case, so this patch is still "nice to have" it
> makes the situation better. for the not-fixed case, we can have
> another patch to address that. Do you agree?

As Alan says, it's in the middle of the merge window right now, and I
can't take any new patches until 3.4-rc1 is out.  It is in my queue to
review when the merge window is over.

patience please,

greg k-h
