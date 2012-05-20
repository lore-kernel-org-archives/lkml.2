Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2ETQSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 12:18:49 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35667
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316Ab2ETQSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 12:18:48 -0400
Date: Sun, 20 May 2012 12:18:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: jonas@southpole.se, linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OpenRISC: Make do_signal() non-static
Message-ID: <20120520161839.GA16706@infradead.org>
References: <1337426347-3557-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337426347-3557-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 01:19:07PM +0200, Richard Weinberger wrote:
> There is no need to export this function.

s/non-static/static/ in the subject?

