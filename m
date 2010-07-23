Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0GWH7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 03:59:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62832 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0GWH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 03:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QKMgPml0NPZecjsANOAT3+fgQOHvt3NZTBZB5wMs5sIUHccyeui8DqM69eoItjtbmR
         6JZXqh9HwOtn0MouKBo4+rmf5Q0+txoAIMngYESfDB3BlyFwXbrruqSNlWMs9jIRCzkJ
         hXf/l5r9K91x9QIV99xHw0BWhQwdCEQkngYi0=
Date: Fri, 23 Jul 2010 16:03:03 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: zhanglx <zhanglx@semico.com.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about net subsystem
Message-ID: <20100723080303.GA5822@cr0.nay.redhat.com>
References: <007001cb293c$36ec6630$3701a8c0@wxintech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007001cb293c$36ec6630$3701a8c0@wxintech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 09:21:30AM +0800, zhanglx wrote:
>hello,
>
>I have some questions about net subsystem.
>
>Does the kernel code store the IP address of local machine, in which variable?


Yes, it is in a per-interface struct, you must be interested in how
SIOCGIFADDR is handled.

>
>If there are two net cards, then there will be two IP and MAC address, how will the kernel store them? When there are two net cards, which card will the PC use to connect to net.
>


This depends on your route table. :)


>Does the webbrowser such as Firefox also use the series of functions( sock(), connect(), send(),receive()...) to connect to internet?
>

Sure.

Hope this helps.
