Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0DYJfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:35:37 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:49780 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0DYJff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=EQ6LcDsMgxskbjLsiKTh75XJV6kg56Oh8ggI/GwqnRCUCaNyuubhi9SZnS7/qYeDB0
         WIG5FOTRYdvIv6GHJ+QFAdQloUgOiG6Wb74+lZsICQEOtdkGQgF2uSW/nXgZmr5hF/+u
         wMU2xxFP3RgAbWw2qcA2IUHH60TePPRveD4W8=
MIME-Version: 1.0
In-Reply-To: <1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-2-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-3-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-4-git-send-email-xiaohui.xin@intel.com> 
	<1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 25 Apr 2010 17:35:01 +0800
Message-ID: <t2z412e6f7f1004250235ib1002b3doe604d786dadefaa5@mail.gmail.com>
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

bool return value should be better here.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
