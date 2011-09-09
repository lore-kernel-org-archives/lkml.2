Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867Ab1IIMsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:48:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34261
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933423Ab1IIMsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:48:18 -0400
Date: Fri, 9 Sep 2011 08:48:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Christoph Hellwig <hch@tuxera.com>, Pavel Ivanov <paivanof@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110909124813.GB29337@infradead.org>
References: <20110907175952.GC23829@thinkpad-t410>
 <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
 <20110908162303.GA18435@ubuntu-NB505>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908162303.GA18435@ubuntu-NB505>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 09:23:04AM -0700, Seth Forshee wrote:
> That was my patch submission :)
> 
> Christoph, does that work for you, or would you like me to send the
> patch in a separate email?

The submission is fine.  I'll try to find a QA setup to test it properly
and will send it on to Linus afterwards.
