Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0DOM1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 08:27:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49641 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab0DOM1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 08:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XaUeJKQuX/HGrcXtGuT7BkYsVCdxARTTQSGtc65WOfY6of9ABwgDpV/3Du8FfT55Uh
         h7x2fxtn3v6beJqnAqRt1zg9tUQZKIa5piOaDbKF/6+X+5ZOLv1JGxiO9yGs0OKLIF0p
         vkypOMNEqF/vljWc2A8HJ8I7UmFjYIQIP/MO4=
MIME-Version: 1.0
In-Reply-To: <1271333540.3042.17.camel@dhcp235-240.rdu.redhat.com>
References: <20100415055132.GA3921@localhost.localdomain>
	 <1271333540.3042.17.camel@dhcp235-240.rdu.redhat.com>
Date: Thu, 15 Apr 2010 20:27:45 +0800
Message-ID: <n2h628d1651004150527k5db402a3rd66292aa58a8c595@mail.gmail.com>
Subject: Re: [RFC][PATCH] Security: fix cap_file_mmap() off-by-one error to 
	avoid kernel null pointer exploit
From: wzt wzt <wzt.wzt@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org, eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The fix to the comment is fine, but you missed the point ENTIRELY.
i'll send a new patch only fix the comment.

> The WHOLE point of being able to set dac_mmap_min_addr == 0 is so you can
> disable the protection.  There exist tools (wine and dosemu) which NEED
> to map the 0 page.
 thanks for explain it, i really understood wrong before.
