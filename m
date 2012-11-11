Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2KKSQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:16:38 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50962 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2KKSQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:16:37 -0500
MIME-Version: 1.0
In-Reply-To: <1352215711.3692.1.camel@phoenix>
References: <1352215711.3692.1.camel@phoenix>
Date: Sun, 11 Nov 2012 19:16:36 +0100
Message-ID: <CACRpkdYMqZYtU5OyErxSWh=yJ8f7ijxxMFnUGQ2Xmn2FB6wcng@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: Remove a redundant settting for ctrldesc->npins
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 4:28 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Set it once is enough.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Kyungmin's ACK, thanks!
Linus Walleij
