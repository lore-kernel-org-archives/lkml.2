Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2C1I01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:26:27 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:32970 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2C1I0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:26:25 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: array underflow in receive_SyncParam()?
Date: Wed, 28 Mar 2012 10:26:23 +0200
Message-ID: <6830387.jTXYMTo9KI@fat-tyre>
Organization: LINBIT
User-Agent: KMail/4.7.3 (Linux/3.0.0-16-generic; KDE/4.7.4; i686; ; )
In-Reply-To: <20120327114343.GB3200@mwanda>
References: <20120327071036.GA19008@elgon.mountain> <2865608.JOP40HBeUa@fat-tyre> <20120327114343.GB3200@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. März 2012, 14:43:43 schrieb Dan Carpenter:
> On Tue, Mar 27, 2012 at 01:32:35PM +0200, Philipp Reisner wrote:
> > Hi Dan,
> > 
> > You are right, we are relying on the fact that DRBD peers that
> > use the protocol 88 send a positive data_size (what they do).
> > 
> > But if we consider a modified peer, then this is a bug. Suggesting
> 
> > the following patch:
> Looks good to me.  Could you give me a Reported-by tag when you send
> this?
> 

Sure. Right now it is here, in out out-of-tree repo.

http://git.drbd.org/gitweb.cgi?p=drbd-8.3.git;a=commit;h=02d3c4dd5da22e8a2e8c953fe20f32de1124fedb

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

