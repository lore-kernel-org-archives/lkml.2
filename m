Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031262Ab2CPVBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:01:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58542 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2CPVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:01:35 -0400
Message-ID: <4F63AA2C.7050009@suse.cz>
Date: Fri, 16 Mar 2012 22:01:32 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Du, Alek" <alek.du@intel.com>, "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH v2] tty: hold lock across tty buffer finding and buffer
 filling
References: <EE928378561BF1449699C96571234A740FCC5EC3@SHSMSX102.ccr.corp.intel.com> <20120316201445.GA1240@kroah.com>
In-Reply-To: <20120316201445.GA1240@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 09:14 PM, gregkh@linuxfoundation.org wrote:
> Do you have any objections to me applying the patch below?

The only issue with the patch is that I'm not convinced it fixes
tty_prepare_flip_string* properly. I don't think it improves anything there.

thanks,
-- 
js
suse labs
