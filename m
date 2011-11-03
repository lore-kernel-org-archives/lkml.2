Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1KCHLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:11:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52958 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1KCHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:11:10 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.21.55]
In-Reply-To: <1320302748.17983.0.camel@phoenix>
References: <1320302748.17983.0.camel@phoenix>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 3 Nov 2011 09:10:49 +0200
Message-ID: <CAK=WgbYgvW36+qv92ft5U_GLCQH_-H9gUU5DKyaMP5Ui+vxthQ@mail.gmail.com>
Subject: Re: [PATCH] hwspinlock: Don't return a value in __hwspin_unlock
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 3, 2011 at 8:45 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Fix below build warning:

Applied, thanks!
