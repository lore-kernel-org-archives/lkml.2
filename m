Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1D1L7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:59:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1D1L7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gcaop+ne/w3FJdL8zzssSxi+fmGUNvVA5Q1byxB7mHMKz4oqowC0hwoEasddNnxaJA
         EQ2zevJm5hA4vo0Y9ar1n9h/AWeuqj20MhSJ55hAc3NmiK2cAouoApgXnrjUBgZqHXHi
         kFhRgJ3vjJYzfCm6LB9Ghq8bTgA88OSPA6rQQ=
Subject: RE: Low performance Intel 10GE NIC (3.2.10) on 2.6.38 Kernel
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dana Rubin <dana4kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTikpVTudMWsteoRYgkPFxtsKsKrtZQ@mail.gmail.com>
References: <BANLkTikpVTudMWsteoRYgkPFxtsKsKrtZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 13:58:54 +0200
Message-ID: <1303991934.3360.62.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 28 avril 2011 à 14:23 +0300, Dana Rubin a écrit :
> Hi,
> 
> the same phenomenon that described in thread
> http://www.spinics.net/lists/netdev/msg160549.html
> is reproducible in IBM x3850 X5 with Intel X520 Dual Nic.
> 
> Please, let me know if there is any additional information from that
> system that can be in use to resolve the problem.

Maybe you could :

- post to netdev instead of linux-kernel

- Try various things that were suggested to Wei Gu, and give all needed
information.


