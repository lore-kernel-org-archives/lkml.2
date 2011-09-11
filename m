Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab1IKOKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:10:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44544
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab1IKOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:10:47 -0400
Date: Sun, 11 Sep 2011 10:10:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Christoph Hellwig <hch@tuxera.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
Message-ID: <20110911141040.GA23339@infradead.org>
References: <20110907175952.GC23829@thinkpad-t410>
 <1315451581.92826.YahooMailClassic@web29509.mail.ird.yahoo.com>
 <20110908162303.GA18435@ubuntu-NB505>
 <CAG1a4rvfajX8BwbL39UP5PYcwMLi_GETS3psq7cZv48UvZv0Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG1a4rvfajX8BwbL39UP5PYcwMLi_GETS3psq7cZv48UvZv0Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 10, 2011 at 11:32:15PM -0400, Pavel Ivanov wrote:
> Seth, Christoph,
> 
> I've just found another wrong pointers freeing. The following patch
> should fix it.

I'd like to throw this into Seths previous patch, while adding an
ACK for your finding.  Is that fine with you?

