Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1EDRbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:31:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63791 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab1EDRbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:31:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qEyxa/MkFnzvdq19jhWm230Wg9TeK5YBlFZvIjR9alJDtdgoFI5x2saKfcfMEJLJ/d
         gUsFelyMPfnEp1N94p7vSPYNxcWad5mIjaSyLISuXgSEbLJXvBquukIM6cFgCeF8QSdY
         pUD/ih/vykGdu7QJbihvGRH/W4GE/OgTUYxxw=
MIME-Version: 1.0
In-Reply-To: <4DC171EB.6030900@googlemail.com>
References: <1304455330-2728-1-git-send-email-abogani@kernel.org>
	<4DC171EB.6030900@googlemail.com>
Date: Wed, 4 May 2011 19:30:58 +0200
X-Google-Sender-Auth: 9OkpBs4hq_tMNlTWJtxmaoeayqo
Message-ID: <BANLkTimFmSEykpoOWkicOe8vQFZNZdFoFA@mail.gmail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
From: Alessio Igor Bogani <abogani@kernel.org>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Behme,

2011/5/4 Dirk Behme <dirk.behme@googlemail.com>:
[...]
> How is this patch related to patch 4/4
>
> http://marc.info/?l=linux-kernel&m=130296062420328&w=1
>
> of the recently sent patch set? Is it a replacement? Or an add on to this
> (i.e. patch #5)?

Sorry it's my fault: This patch is an add on to that patch set.

Ciao,
Alessio
