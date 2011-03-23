Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1CWQEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:04:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37736 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab1CWQEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E4mxPoz8goTPtJn/zUB+ttsfa3AK9USC4nZUbkUsugVkhPTI3QYJfyy84hXgVb/+td
         /gvnAyjng2xqSIxBKopxnyscBx5m7DpGD+Tlhl5qxGHp1TqFPsiruVFsxoH+BiuhCteq
         xhTPqbKzMgNXsVSrLEzWe5WCHx5qM5G/7IRCs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinWrchYyqF8qAGGQAt9JCbAj46txqK-MD2TEZe1@mail.gmail.com>
References: <AANLkTinWrchYyqF8qAGGQAt9JCbAj46txqK-MD2TEZe1@mail.gmail.com>
Date: Thu, 24 Mar 2011 00:04:09 +0800
Message-ID: <AANLkTi=N4JbadNtOWNdNzQU7Go7LTrv9TQS7jDMccamq@mail.gmail.com>
Subject: Re: sched: new cpu schedule
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: wu junhui <wjh.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:34 PM, wu junhui <wjh.kernel@gmail.com> wrote:
> hello
>
> i have a new cpu schedule, i name it NanJing for my city.
>
> it's O(1),
> it's one queue,
> it's load balance o(1),
> it's fair,
> it's i/o friendly,
...
>
> my developing  platform is centos 5.5
>
> rpmbuild -bp 2.6.18-194.32.1.el5 source
>

Don't you know we have CFS since 2.6.23?
