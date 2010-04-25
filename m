Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0DYJd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:33:27 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:44973 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0DYJdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kdob5dxFnhe6wsY9DCJ/UQJxYGHq2l2TAk0NB2tBl2igZxBwuFjsoCpgHE0TFFoIwJ
         JJnDZlqb/2OIofukGSzN6yP/umz5YUn1+7pvvrjRZSOMgtZdLUlxI7Ic8CTsBe3WRHEV
         5sYMMDZrUXo1VRDEAZ0vkFLuYeNpwJ5+7Kn5Y=
MIME-Version: 1.0
In-Reply-To: <1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-2-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-3-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-4-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 25 Apr 2010 17:33:02 +0800
Message-ID: <t2g412e6f7f1004250233pbdfe4d8aj7dc0e0a4980d8eb9@mail.gmail.com>
Subject: Re: [RFC][PATCH v4 05/18] Add a function to indicate if device use 
	external buffer.
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 5:19 PM,  <xiaohui.xin@intel.com> wrote:
> +static int dev_is_mpassthru(struct net_device *dev)
> +{
> +       if (dev && dev->mp_port)
> +               return 1;
> +       return 0;
> +}
> +

Please make it a inline function. And you would write it with less
lines of code.

return dev && dev->mp_port;


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
