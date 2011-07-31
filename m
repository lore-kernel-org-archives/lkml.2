Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1GaWV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 18:21:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:42154 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1GaWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 18:21:52 -0400
Subject: Re: [PATCH 1/2] kconfig: Factor out conf_validate_choice_val()
 function from conf_read_simple()
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Sun, 31 Jul 2011 23:21:47 +0100
In-Reply-To: <1312078662-20278-1-git-send-email-lacombar@gmail.com>
References: <1312067626.22074.60.camel@i7.infradead.org>
	 <1312078662-20278-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312150909.18010.23.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 22:17 -0400, Arnaud Lacombe wrote:
> 
> I would go a little further and apply the attached patch too, The two jump
> site to `setsym' do not meet the conditionnal and can be avoided. 

Makes sense. It also makes sense to do that as a separate patch; the one
moving code around should *just* move code around. Want to let me have a
Signed-off-by: for it, and I'll add it to
 git://git.infradead.org/users/dwmw2/x86merge.git

Thanks.

-- 
dwmw2

