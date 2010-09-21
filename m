Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0IUVYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:24:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322Ab0IUVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:24:20 -0400
Date: Tue, 21 Sep 2010 23:24:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] hid: 3m: Convert to MT slots
In-Reply-To: <83EE14B9-C3BB-43DA-AF0B-962EA40C0DB5@enac.fr>
Message-ID: <alpine.LNX.2.00.1009212324100.26813@pobox.suse.cz>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>    <1283005748-3293-2-git-send-email-rydberg@euromail.se>    <CE1C24FC-7C9A-4940-8141-391A368C59E5@enac.fr>   <4C97BB33.5020806@euromail.se>   <6A8BB954-78BB-4507-86F3-19DA5174FA5E@enac.fr>
  <4C97BE69.2030100@euromail.se>  <EBFF8B5B-5361-45B3-88B8-8254E3953578@enac.fr> <4C98ED5B.7020408@euromail.se> <83EE14B9-C3BB-43DA-AF0B-962EA40C0DB5@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Stéphane Chatty wrote:

> > > Anyway, I have no more problem with this constant. Just with the 
> > > vocabulary :-)
> > 
> > In the HID protocol, it is called ContactID... So, Stéphane, are we 
> > close to acking this patch now? :-)
> 
> Oh yes of course, I was not clear enough in the above message. To make things
> more formal:
> 
> Acked-by: Stéphane Chatty <chaty@enac.fr>

Applied, thanks!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
