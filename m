Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab2LQRV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:21:58 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:57621 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052Ab2LQRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:21:57 -0500
Message-ID: <50CF548C.2080500@st.com>
Date: Mon, 17 Dec 2012 18:21:16 +0100
From: Armando Visconti <armando.visconti@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] usb: gadget zero: avoid unnecessary reinit of data in
 f_sourcesink
References: <1355407879-11784-1-git-send-email-armando.visconti@st.com> <20121217154545.GB5931@breakpoint.cc>
In-Reply-To: <20121217154545.GB5931@breakpoint.cc>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 04:45 PM, Sebastian Andrzej Siewior wrote:
> On Thu, Dec 13, 2012 at 03:11:19PM +0100, Armando Visconti wrote:
>> In the IN case, since the USB request is allocated only when
>> the source/sink function is started and never freed, the USB ept
>> buffer needs to be inited only at the beginning. This change
>                       ^^^^^^
>> results into a more performant g_zero module, especially when
>> 'pattern=1' is selected.
>
> Besides that the patch looks fine :)

Do you mean that 'inited' should be changed with 'initialized'?
Oh ... my poor english... :(

Rgds,
Arm

