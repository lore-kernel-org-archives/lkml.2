Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0ERFFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:05:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34317 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0ERFFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XCCgECfppfHmrepFiiUhIMKr/rYCqDhR6T78sIjKB9csi42E5z2b8+Ajs1YrfhYFLP
         3VdAEEykWEi9qcQMZo5vhrBNiPZ45qp6SeNlvCDamcfx5kjEyWFfMe1OkdrkzIJLtP8H
         zJMZ28VNQasjvmoL2s5s9itTk8x78rQN+HSAs=
Subject: Re: kernel panic
From: Eric Dumazet <eric.dumazet@gmail.com>
To: senthilkumaar2021 <senthilkumaar2021@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BF21DAD.6050609@gmail.com>
References: <4BF21646.60008@gmail.com> <4BF21BD3.60901@gmail.com>
	 <4BF21DAD.6050609@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 07:05:36 +0200
Message-ID: <1274159136.2567.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 mai 2010 à 10:25 +0530, senthilkumaar2021 a écrit :
> Hi
> 
> Thanks for the reply
> 
> Initially i was using kernel 2.6.28.5 and kernel panic occurred in that 
> version too
> 
> tproxy is not supported in linux 2.6.32
> 
> http://wiki.squid-cache.org/Features/Tproxy4
> 
> kindly guide me how to proceed

Please submit full panic log, and kernel version

AFAIK tproxy is now in Linux kernel tree.



