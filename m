Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab2JKRmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:42:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50476
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964797Ab2JKRmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:42:04 -0400
Date: Thu, 11 Oct 2012 13:41:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: ????????? Yang Su Li <suli@cs.wisc.edu>
Cc: General Discussion of SQLite Database <sqlite-users@sqlite.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
Message-ID: <20121011174157.GA32038@infradead.org>
References: <CALwJ=MzHjAOs4J4kGH6HLdwP8E88StDWyAPVumNg9zCWpS9Tdg@mail.gmail.com>
 <m2fw5mtffg.fsf_-_@firstfloor.org>
 <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 11:32:27AM -0500, ????????? Yang Su Li wrote:
> I am not quite whether I should ask this question here, but in terms
> of light weight barrier/fsync, could anyone tell me why the device
> driver / OS provide the barrier interface other than some other
> abstractions anyway? I am sorry if this sounds like a stupid questions
> or it has been discussed before....

It does not.  Except for the legacy mount option naming there is no such
thing as a barrier in Linux these days.

