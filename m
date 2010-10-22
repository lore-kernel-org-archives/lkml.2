Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab0JVUPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:15:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43736 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab0JVUPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZTQWBLq/NN1xB5i5HeK2OVC3uckqVhNzU/HBRhaENgKQ+TMPQhSDQnIaq34Yg/Mx+m
         R1K1pcM2QdGTK1/kzMoqxIN1mpiI7XVI0xlrSCezZk/WvhTNHRCqsZFLmW2+VitvwndP
         no8G74S4I/ZwWl6ntxZL2FBbWIh0T23/sfTNw=
MIME-Version: 1.0
In-Reply-To: <cover.1287724261.git.joe@perches.com>
References: <cover.1287724261.git.joe@perches.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 22 Oct 2010 16:15:29 -0400
Message-ID: <AANLkTi=qAAC6cFiR9iG9G0f9B+jOCSQfbi7xGUm43oAV@mail.gmail.com>
Subject: Re: [PATCH 0/9] Typo fixes of faild to failed
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        rtc-linux@googlegroups.com, osd-dev@open-osd.org,
        jfs-discussion@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 01:17, Joe Perches wrote:
>  drivers/ata/pata_bf54x.c           |    2 +-
>  drivers/video/bf54x-lq043fb.c      |    6 +++---
>  drivers/video/bfin-t350mcqb-fb.c   |    2 +-

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
