Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2FOLUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:20:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42496 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2FOLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:20:18 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1339711676-3488-1-git-send-email-prakity@marvell.com>
References: <1339711676-3488-1-git-send-email-prakity@marvell.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 15 Jun 2012 19:19:57 +0800
Message-ID: <CAF+7xWnXL_2AvZ_5TR+fa-yMOf6qbK+m8p3pkPJQVbHzPw-zhg@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: core.c Only delay when setting voltage
 requires this
To: Philip Rakity <philipspatches@gmail.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
        linux-mmc@vger.kernel.org, Philip Rakity <prakity@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/15 Philip Rakity <philipspatches@gmail.com>:
> minor optimization: move delay code to where delay is set and
> thus where it is used vs in the main line path.
>
> Signed-off-by: Philip Rakity <prakity@marvell.com>
Acked-by: Axel Lin <axel.lin@gmail.com>
