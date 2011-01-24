Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1AXPZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:25:54 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54499 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1AXPZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=swkpw7LgNF8cT5TVVeYHMDw6eJp5T9HiTDD2Tjtu2fSwb40oeLl9fgEom5zrJnW8iO
         H8y4UuweujRKseNLt1Fim0CGzm5EG08cRuul9J04bZoeNMQVj2AOM3ybxbPKwD9zeGz5
         SSXpk2yVWW0tcPxm2FqO7DurlMurdsKUvqC3Q=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jesse Gross <jesse@nicira.com>
Subject: Re: 2.6.37 regression: adding main interface to a bridge breaks vlan interface RX
Date: Mon, 24 Jan 2011 16:25:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
Cc: Simon Arlott <simon@fire.lp0.eu>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4D32FC1C.3010905@simon.arlott.org.uk> <201101231845.20505.maciej.rutecki@gmail.com> <AANLkTimTz=kMmJ=YhyJv28WUrsbN=ygBt9e7dMJ3KGqB@mail.gmail.com>
In-Reply-To: <AANLkTimTz=kMmJ=YhyJv28WUrsbN=ygBt9e7dMJ3KGqB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101241625.45367.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On niedziela, 23 stycznia 2011 o 22:29:02 Jesse Gross wrote:
> On Sun, Jan 23, 2011 at 9:45 AM, Maciej Rutecki
> 
> <maciej.rutecki@gmail.com> wrote:
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=27432
> > for your bug report, please add your address to the CC list in there,
> > thanks!
> 
> This isn't a bug - the change resolved behavior that varied depending
> on what NIC was in use.

Thanks for the update. Closing.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
