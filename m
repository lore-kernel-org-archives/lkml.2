Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab0DKJcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 05:32:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61245 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab0DKJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 05:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=A+SlaoYjtdXMFdco5UbJsoJrIeji7h+PTgLNDYaVTg9UHucjgONmWZvZDJxRhIy4S/
         5hWs6/4C1vyDH94UVPpTlwnsSgZNZZwKh9dxodMp3NUyAnzZvPXir8L58vUYhcq5lsxH
         HMS+/xiJrElHRECdeXCO1FOrgFQ4sfwIvylQ8=
MIME-Version: 1.0
In-Reply-To: <20100411.022416.107236208.davem@davemloft.net>
References: <r2v86802c441004110217u15591f95ydd1e8e1466a36dc2@mail.gmail.com>
	 <20100411.022416.107236208.davem@davemloft.net>
Date: Sun, 11 Apr 2010 02:32:33 -0700
X-Google-Sender-Auth: be1dcba7672ae69f
Message-ID: <u2v86802c441004110232l99be1450w4e629ab2bde9bc0c@mail.gmail.com>
Subject: Re: ssh server etc doesn't work anymore with net-2.6
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 2:24 AM, David Miller <davem@davemloft.net> wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> Date: Sun, 11 Apr 2010 02:17:09 -0700
>
>> it will make sshd server, telnet server and vnc server doesn't respond
>> connecting request anymore.
>
> What kind of network device are you using?
>
> And regardless of the underlying physical network device, are you
> going over some virtual device such as a tunnel, a bonding device, or
> a virtualization network interface?

server side: 82576 with net-2.6
client side: opensuse 11.2 on thinkpad T61 wireless + vpnc

Yinghai
