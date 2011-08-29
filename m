Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1H2Wrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:47:36 -0400
Received: from yaina.de ([78.46.107.162]:36035 "EHLO mail.yaina.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab1H2Wre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:47:34 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 18:47:34 EDT
Date: Tue, 30 Aug 2011 00:42:00 +0200
From: Joerg Reuter <jreuter@yaina.de>
To: Joe Perches <joe@perches.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/24] ax25: Remove unnecessary OOM logging messages
Message-ID: <20110829224159.GB23854@yaina.de>
References: <cover.1314650069.git.joe@perches.com>
 <a426e678426cf2be1552edfbbb0de7ce08e9a7ef.1314650069.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a426e678426cf2be1552edfbbb0de7ce08e9a7ef.1314650069.git.joe@perches.com>
X-Face: #DGJ)DCeau/h"w7G~n9r|/jxvQQrtU)nat27v-><7':==-=.mfnXc+8&qOj`*R|qPr14[|4
 E_BUo5T*NT\(+fE7wr3}QoN*!c7\.Z.DiA{ko;01^TCi$K}1TIV|bNO.$jm;i<A,|
X-Message-Flag: Your mail client is broken beyond repair
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 02:17:23PM -0700, Joe Perches wrote:

> Removing unnecessary messages saves code and text.

Not really that much of an impact, but yes, I agree it just swamps
syslog with duplicate messages... It was more debug code than
anything else originally. Beats me why it is logged as KERN_ERR or
KERN_CRIT, being out of buffers is not really fatal or even
unusual.

Still alive with just not enough time for hamradio stuff nowadays,
	Joerg DL1BKE

-- 
Joerg Reuter                                    http://yaina.de/jreuter
And I make my way to where the warm scent of soil fills the evening air. 
Everything is waiting quietly out there....                 (Anne Clark)

