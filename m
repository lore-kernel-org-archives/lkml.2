Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2LEBeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:34:21 -0500
Received: from intranet.asianux.com ([58.214.24.6]:51094 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2LEBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:34:18 -0500
X-Spam-Score: -100.8
Message-ID: <50BEA4CF.2030207@asianux.com>
Date: Wed, 05 Dec 2012 09:35:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] synclink fix ldisc buffer argument
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com> <50B8DDAC.8070901@microgate.com> <50B90D0D.9040401@microgate.com> <50BCDDB4.6010608@microgate.com>
In-Reply-To: <50BCDDB4.6010608@microgate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年12月04日 01:13, Paul Fulghum 写道:
> Fix call to line discipline receive_buf by synclink drivers.
> Dummy flag buffer argument is ignored by N_HDLC line discipline but might
> be of insufficient size if accessed by a different line discipline
> selected by mistake. flag buffer allocation now matches max size of data
> buffer. Unused char_buf buffers are removed.
> 
> Signed-off-by: Paul Fulghum <paulkf@microgate.com>
> 

  thank you very much.


  might we use macro instead of hard code number ? (such as 4096,
65535). it is only an idea, not means need regression.

  thanks.

-- 
Chen Gang

Asianux Corporation
