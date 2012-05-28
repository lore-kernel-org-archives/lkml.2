Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2E1Ca5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 22:30:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54858 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab2E1Ca4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 22:30:56 -0400
MIME-Version: 1.0
In-Reply-To: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
References: <1338152074-30747-1-git-send-email-devendra.aaru@gmail.com>
Date: Sun, 27 May 2012 22:30:54 -0400
Message-ID: <CAKPrQY8O0=PQroL6vYOCATG3WUx1ChgqW9rFqhuY2G7Q7oj3WA@mail.gmail.com>
Subject: Re: [PATCH] [staging] bcm: Fix codingstyle problems
From: Kevin McKinney <klmckinney1@gmail.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devendra,

On Sun, May 27, 2012 at 4:54 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/bcm/Debug.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
I understand this is a simple change, but please add a descriptive
change log to your patch for consistency.

Thanks,
Kevin
