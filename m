Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0JBJ6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 05:58:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44425 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab0JBJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 05:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pgP0LMXkjDiFLRnJsmaSH2SwyVCpdmpS8SZaHM+IqGD94joreW4vV5BTIISnit02ju
         MxTEUxCNbm9jjaCYvNZ67Qy94QP1fsOr7xpTT7GUN7hD/m1QF0L6aY/P3LC5/VUbZQdN
         JZ/vDB4w5ws8dz2b8bwbOPI5f5IKcgKjHzY5E=
MIME-Version: 1.0
In-Reply-To: <AANLkTimnSzAWJW417_XR60umT_k47AFWDdDPPD3yhbLG@mail.gmail.com>
References: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com>
	<AANLkTi=8LGCVqchpQrB+31FRqK04+3xLFCuak0S1FHpK@mail.gmail.com>
	<AANLkTimnSzAWJW417_XR60umT_k47AFWDdDPPD3yhbLG@mail.gmail.com>
Date: Sat, 2 Oct 2010 17:58:10 +0800
Message-ID: <AANLkTinq16F1oh=gj_hs=w8fMWo7VuArC3m4-SUWp+Nr@mail.gmail.com>
Subject: Re: [PATCH] usb: core: endpoint: Fix error path
From: Ming Lei <tom.leiming@gmail.com>
To: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/2 Rahul Ruikar <rahul.ruikar@gmail.com>:
> revised patch attached.

Acked-by: Ming Lei <tom.leiming@gmail.com>

-- 
Lei Ming
