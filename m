Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab1DLJmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:42:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1DLJmP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:42:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=TwfaLotQcAa0ZbKwGgsB1nL8IxdOOxzfnyeBKRMsPneyf3nYuc5eQQyGbN6VBB8hCU
         MKo3/mVN5+meeko0LzNtnAi/ms/sNYcE6C/+ZvgddEm87Yu/dWqLqaYxWYRjKEyXYQK6
         K/w8j4X1+9VuhBSxcnlMbAjHSTB5rNk4GRcko=
Date: Tue, 12 Apr 2011 11:42:10 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Adam McLaurin" <lkml@irotas.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Loopback and Nagle's algorithm
Message-ID: <20110412114210.65f202cc@varda>
In-Reply-To: <1302575869.13492.1440076201@webmail.messagingengine.com>
References: <1302575869.13492.1440076201@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 11 Apr 2011 22:37:49 -0400
"Adam McLaurin" <lkml@irotas.net> escribió:

 Just CCing netdev

> I understand that disabling Nagle's algorithm via TCP_NODELAY will
> generally degrade throughput. However, in my scenario (150 byte
> messages, sending as fast as possible), the actual throughput penalty
> over the network is marginal (maybe 10% at most).
> 
> However, when I disable Nagle's algorithm when connecting over loopback,
> the performance hit is *huge* - 10x reduction in throughput.
> 
> The question is, why is disabling Nagle's algorithm on loopback so much
> worse w.r.t. throughput? Is there anything I can do to reduce the
> incurred throughput penalty?
> 
> Thanks,
> Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
