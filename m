Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0EFQQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:16:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51966 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0EFQQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o5VoOBtAl2XiDgdNw6CYjFbmLGp5AFFyIWMGmk+lrVQf4OB5/MZYPCaiXkU9VmJGqW
         fWpiw7EPCT5IfvhfALJDRQuwYsbPBOqZ3XTU0FZkQbRsxYVz4Le86QqFsbTxRV24qx/T
         fniDaBpmTfN3qIpjyMmFoioPfEqTtR9N07kr4=
MIME-Version: 1.0
In-Reply-To: <7841.1273161966@localhost>
References: <7841.1273161966@localhost>
Date: Thu, 6 May 2010 18:16:26 +0200
Message-ID: <j2gb170af451005060916of64cbd20x12ea697de19931b2@mail.gmail.com>
Subject: Re: linux-next - drm/ttm versus nouveau - WARNING and dead driver.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/6  <Valdis.Kletnieks@vt.edu>:
> Bisected down to:
>
> 82c5da6bf8b55a931b042fb531083863d26c8020 is the first bad commit
> commit 82c5da6bf8b55a931b042fb531083863d26c8020
> Author: Jerome Glisse <jglisse@redhat.com>
> Date:   Fri Apr 9 14:39:23 2010 +0200
>
>    drm/ttm: ttm_fault callback to allow driver to handle bo placement V6

Can this be duplicate of https://bugs.freedesktop.org/show_bug.cgi?id=27822 ?

-- 
Rafał
