Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1KAMzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:55:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52341 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1KAMzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:55:11 -0400
Date: Tue, 1 Nov 2011 13:54:54 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the edac tree
Message-ID: <20111101125454.GA21877@aftab>
References: <20111101170000.6e7301a30bc21e917631eb88@canb.auug.org.au>
 <4EAFDECA.3040007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAFDECA.3040007@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 07:58:02AM -0400, Mauro Carvalho Chehab wrote:
> Sorry, it were caused by a bad merge conflict resolution. The include
> isn't need anymore.
> 
> The MAINTAINERS fix is indeed needed.
> 
> > I have used the version of the edac tree from next-20111025 for today.
> 
> I'm fixing both issues for tomorrow's next.

Btw, you're sending those to Linus soon, right?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
