Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0GGP4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:56:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab0GGP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=RNUnjvl7AMn36f3tssyGhqAuL2fHn6JcEyAOu5ZjuO3oLwC4ufHv5eOa28S82mykKi
         d6UHBaUbHX8Rr2o8p6HsaTs4V0Ga7CD7JkbEJY8+M26UyVk6CBIBRq4vf5EPjIVHm+bu
         8jRVRAYJYLsu8b3x6t1EPVXCjoKYoGg3oPauo=
MIME-Version: 1.0
In-Reply-To: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
Date: Wed, 7 Jul 2010 17:56:05 +0200
Message-ID: <AANLkTinp8IG3t_A71DBqJYiRdIla6JDU6lyRjLR8zcWG@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Jens' mail address, and resending the patches based on for-2.6.36 tree.
On Wed, Jul 7, 2010 at 5:22 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> Hi Jens,
> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
> suspected for some regressions on high end hardware.
> The two patches from this series:
> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
> fix two issues that I have identified, related to how RQ_NOIDLE is
> used by the upper layers.
> First patch makes sure that a RQ_NOIDLE coming after a sequence of
> possibly idling requests from the same queue on the no-idle tree will
> clear the noidle_tree_requires_idle flag.
> Second patch enables RQ_NOIDLE for queues in the idling tree,
> restoring the behaviour pre-8e55063 patch.
>
> An other option to consider is the partial revert of 8e55063, if the
> corner cases we are trying to handle are not frequent enough to
> justify this added complexity.
>
> Thanks,
> Corrado
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
