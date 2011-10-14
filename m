Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1JNIfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 04:35:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47380 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1JNIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 04:34:58 -0400
Subject: Re: [PATCH] mtd: mark block device queue as non-rotational
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dan McGee <dpmcgee@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Oct 2011 11:34:26 +0300
In-Reply-To: <1317187302-13380-1-git-send-email-dpmcgee@gmail.com>
References: <1317187302-13380-1-git-send-email-dpmcgee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318581273.12351.64.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 00:21 -0500, Dan McGee wrote:
> This is similar to what the nbd driver does, among others.
> 
> Signed-off-by: Dan McGee <dpmcgee@gmail.com>

Pushed to l2-mtd-2.6.git, thanks!

-- 
Best Regards,
Artem Bityutskiy

