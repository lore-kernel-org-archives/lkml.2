Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab1CXSpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:45:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1CXSpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jcCT01CHkD4YOoYxavpASL/qcwpoXgwfT9EC0h4Lh/VTV7MKiEavO5nKJdqSYyFV7k
         ZaKvA9W/DDQUdshqPldBlWMpdkbLYyZmWe0q1X+dkEWNyU9XOiD8KBADKIhgnNL4kU1W
         TNrob97mHUwwJFZ3lwFbP+5DLSAsuC6hQvHSU=
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTik+Rf45wUxN86t+Zp7+AXjcJsy0vmZgvmLj-95x@mail.gmail.com>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	 <1300980118.3747.42.camel@edumazet-laptop>
	 <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	 <1300983340.3747.44.camel@edumazet-laptop>
	 <1300986084.3747.101.camel@edumazet-laptop>
	 <AANLkTik+Rf45wUxN86t+Zp7+AXjcJsy0vmZgvmLj-95x@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 19:45:08 +0100
Message-ID: <1300992308.3747.205.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 19:14 +0100, Alessandro Suardi a écrit :

> 
> I will however make one more bug report, as vpnc is broken before
>  and after this patch - have to dig out what vpnc-script tries to do,
>  which results in
> 
> Error: either "to" is duplicate, or "ipid" is a garbage.
> 
>  after establishing the VPN tunnel.
> 

try following patch

http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=406b6f974dae76a5b795d5c251d11c979a4e509b


