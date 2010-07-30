Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0G3HNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:13:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59009 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab0G3HNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j0YYeozSmc/StlNhLi2OujjJE9CMmyXkcz5QoQ0Yaw5uiihHzagextV/0+rWT48xx4
         M0CqvY47KKXZjBV0E0WXumr+gq5k7WBvxX7rOpXiuxNiOxmXJg11IAlYDPg7TRvguwPJ
         AwHa8Kr1cTE2dXVUUF4qOPUwN/EEnFfiioWL4=
Date: Fri, 30 Jul 2010 15:17:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Guram Z. Savinov" <savinov.guram@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Get interface MAC address in sys_accept4() syscall
Message-ID: <20100730071617.GA5638@cr0.nay.redhat.com>
References: <4C5211D6.3000406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5211D6.3000406@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 03:42:14AM +0400, Guram Z. Savinov wrote:
>Hi all,
>
>in net/socket.c is syscall sys_accept4(). In it syscall I need to get
>MAC address of interface, from connection is come.
>For example it is two interfaces eth0 and eth1. I want to know, from
>what interface connection is come to sys_accept4().
>Please help me, how I can do it.
>

It is not obtained from accept(2), you get it with ioctl SIOCGIFHWADDR.
