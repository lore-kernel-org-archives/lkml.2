Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1EWG1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:27:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60266 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab1EWG12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JdwMMIWruM8GEYfsPtEmq+e031cVqhrI2jQMvHc4nPt4spj1tzKnqG7hRcoWGeCsVW
         Y/kSOgHJOsQaqoB1Lgr3IZ7isyHvlWhdmPWy0v70LUVwed94p3L1Kn5ARUXZJwNsbtLG
         PwTQWz5xyluNuuxxgO6YbB7bpJItTQey1RqME=
Subject: Re: [PATCH] drivers:mtd:fix the bad format in the mtdcore.c
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1305897270-3685-1-git-send-email-wanlong.gao@gmail.com>
References: <1305897270-3685-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 09:23:16 +0300
Message-ID: <1306131796.2785.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 21:14 +0800, Wanlong Gao wrote:
> Remove the spare spaces in the head of the lines.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

Pushed to l2-mtd-2.6.git, thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

