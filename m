Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0I2SRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:17:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33354 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0I2SRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:17:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=frMg52qs7sWT9JCT6WG3g43Z5+ber3ShjUww5z08MzwbLq+YXkMssLtwHV8gNm34nw
         tbC+E08+KnlRNp2i5VFW0K5X4ZHPzaCwdWhYM9qQOQv0TFfEPEPoNseqqRUUDVTl9zHF
         PhEv/qjKDJNWv43vBPlQ78DujDuIhvbPohUrU=
Date: Wed, 29 Sep 2010 20:17:26 +0200
From: Paolo Ornati <ornati@gmail.com>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git bisect selects commit outside initial bisect range?
Message-ID: <20100929201726.195f609b@gmail.com>
In-Reply-To: <201009272051.33882.pluto@agmk.net>
References: <201009272051.33882.pluto@agmk.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 20:51:33 +0200
Paweł Sikora <pluto@agmk.net> wrote:

> i've started git bisect between good-v2.6.34 and bad-v2.6.35-rc1
> and after few steps git-bisect jumps to commit before v2.6.34.

Here there is a "graphical" explaination:

http://kerneltrap.org/mailarchive/linux-kernel/2010/9/1/4614187

Bye,

-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
