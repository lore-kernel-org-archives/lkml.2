Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab2BCVEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:04:37 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:33094 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2BCVEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id
	:subject:from:reply-to:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; q=dns; s=
	dreamhost.com; b=KO/KHguI99qUwvkw/bwaQ2qc41eHTB1IboBcWPTWxqpzP83
	asc+yjRfLRIKn+VR/CsBP3H3Lbtv/fcnY1SLiIKSCOrsZOSeiBsoZCPkxfdjWrzb
	PDUZwcWFP8k4nLnHVjYWJKxk98IUw8eWQwdn0tEheKNZa3waTH76moZZcv24=
Message-ID: <1328303070.21405.91.camel@doink>
Subject: Re: [PATCH RESEND] ceph: avoid panic with mismatched symlink sizes
 in fill_inode()
From: Alex Elder <elder@dreamhost.com>
Reply-To: elder@dreamhost.com
To: Xi Wang <xi.wang@gmail.com>
Cc: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Feb 2012 15:04:30 -0600
In-Reply-To: <972F971B-171E-467D-8E64-C1C49CB94622@gmail.com>
References: <1328280936-2688-1-git-send-email-xi.wang@gmail.com>
	 <1328300672.21405.90.camel@doink>
	 <972F971B-171E-467D-8E64-C1C49CB94622@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 15:49 -0500, Xi Wang wrote:
> On Feb 3, 2012, at 3:24 PM, Alex Elder wrote:
> > Looks good, though it might good to at least call
> > WARN_ON().  What do you think?
> 
> Sounds good to me.  I will send a v2.  Thanks.

No need.  I can do it for you.	-Alex

> - xi
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



