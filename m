Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1CCSxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:53:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46390 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1CCSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:53:43 -0500
Date: Thu, 3 Mar 2011 11:53:40 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, "'Ewe, Kok Howg'" <kok.howg.ewe@intel.com>,
        "'Lai, Mee Sim'" <mee.sim.lai@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: About GPIO interrupt function with sysfs
Message-ID: <20110303185340.GK22940@angua.secretlab.ca>
References: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F5323EE7947C4C1CB0868F843FB4F917@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 09:34:03AM +0900, Tomoya MORINAGA wrote:
> Hi,
> 
> I have a question.
> Can our GPIO driver (pch_gpio) have interrupt function?

Yes, but you cannot use it from userspace via sysfs.  It is only useful for in-kernel users.

g.

