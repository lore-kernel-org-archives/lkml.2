Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2FROTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:19:00 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:37039 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab2FROS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:18:59 -0400
Date: Mon, 18 Jun 2012 15:18:54 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Message-ID: <20120618141854.GA7962@milliways>
References: <20120617200700.GA15348@milliways>
 <1340026956.2451.9.camel@lade.trondhjem.org>
 <1340027134.2451.12.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340027134.2451.12.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=IxJ0d4kOqokA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=72KVqgsFIHSVmlfNzOEA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 01:45:35PM +0000, Myklebust, Trond wrote:
> > 
> > Is this a problem with the client or with the server, and have you tried
> > seeing if the fixes that were merged into -rc3 help?
> 
> Doh... Ignore the second half of the above sentence. error=ENOCOFFEE.
> 
> I would still like to know whether this is a client or server issue
> (i.e. whether a downgrade of one or the other to 3.4 fixes the problem).

 It's the client - the server is still running 3.0.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
