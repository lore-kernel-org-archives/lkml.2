Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1FZLCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 07:02:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42469 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1FZLCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 07:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=r2RY1gAOh6m80JDYW+ys35d+WR0FzXFicyI5av2DR7ZoC7lU7v8ZbMnGLu3k4a6lSb
         Nl31mq50CVhkXyQglkQHfw3I5iS2tQrVAX3K5ofiDbPhw0aHRaodoF9478wljwJFHlQM
         BOY70zOQVJaMsb9H9GH89wTADmXkkulUkaLWc=
MIME-Version: 1.0
In-Reply-To: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
Date: Sun, 26 Jun 2011 13:02:13 +0200
Message-ID: <BANLkTikX-fYqG+1118UmzkAMQc1TSvG+qw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Introduce a led trigger for CPU activity
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/26 Bryan Wu <bryan.wu@canonical.com>:

> Based on Linus Walleij's ARM LED consolidation work, this patchset introduce a
> new generic led trigger for CPU not only for ARM but also for others.

Aha like that, OK I buy it. Just a few comments before I ACK it!

Linus Walleij
