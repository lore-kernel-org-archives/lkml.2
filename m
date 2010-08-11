Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0HKEkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 00:40:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:51843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0HKEkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 00:40:05 -0400
Date: Tue, 10 Aug 2010 21:39:52 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: "Wang, Qi" <qi.wang@intel.com>, meego-dev@meego.com,
        LKML <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>,
        arjan@linux.intel.com
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-ID: <20100811043952.GA4669@suse.de>
References: <002c01cb390e$80a58e50$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002c01cb390e$80a58e50$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 01:34:33PM +0900, Masayuki Ohtake wrote:
> Hi Qi-san
> 
> I have found Macro 'TRUE' and 'FALSE' are used as setting value in the driver; still,
> can't I use TRUE/FALSE macro ?
> If not, How should we implement ?

Use the 'bool' type, and 'true' and/or 'false' keywords instead.  That
is the proper C idiom.

thanks,

greg k-h
