Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab0I0SLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:11:37 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:49860 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab0I0SLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:11:36 -0400
X-Greylist: delayed 1443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 14:11:36 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=
	mime-version:in-reply-to:references:date:message-id:subject:from
	:to:cc:content-type; q=dns; s=drama; b=Ds8kGxhgQMGPteEf9pv2F+5+I
	TRxmb7938vRbj46HFPFEnTM2oJBwzpeZ2FP6ltIBNd9l/RVOI23fpg/e5Sz+mU6e
	58c7rgsMGGxlB8GNC/9JOSP3OHUGRubaPaGkLDkbF+YSkf/3fnxJLFbbvOuSb5hu
	BJ8zdGNUt2S5R29hnw=
MIME-Version: 1.0
In-Reply-To: <1285491578-32580-1-git-send-email-segooon@gmail.com>
References: <1285491578-32580-1-git-send-email-segooon@gmail.com>
Date: Mon, 27 Sep 2010 10:47:21 -0700
Message-ID: <AANLkTinN_o2O1amBvsM7nFp_ozp13zRPZm=RNH5cp+DV@mail.gmail.com>
Subject: Re: [PATCH] block: rbd: fixed may leaks
From: Yehuda Sadeh Weinraub <yehuda@hq.newdream.net>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 1:59 AM, Vasiliy Kulikov <segooon@gmail.com> wrote:
> rbd_client_create() doesn't free rbdc, this leads to many leaks.
>
> seg_len in rbd_do_op() is unsigned, so (seg_len < 0) makes no sense.
> Also if fixed check fails then seg_name is leaked.
> ---

Pushed to our unstable tree. Added missing signed-off by.

Thanks,
Yehuda
