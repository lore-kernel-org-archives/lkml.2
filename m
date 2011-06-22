Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab1FVUFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:05:44 -0400
Received: from mail.southpole.se ([193.12.106.18]:56122 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab1FVUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:05:43 -0400
Subject: Re: [PATCH 14/19] OpenRISC: Module support
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <201106222158.11381.arnd@arndb.de>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	 <201106221626.12023.arnd@arndb.de> <1308770050.20122.4951.camel@localhost>
	 <201106222158.11381.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole Consulting AB
Date: Wed, 22 Jun 2011 22:05:39 +0200
Message-ID: <1308773139.20122.5268.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2011-06-22 at 21:58 +0200, Arnd Bergmann wrote:
> On Wednesday 22 June 2011 21:14:10 Jonas Bonn wrote:
> > What's an acceptable "comment title"?  Most other arch's seem to put the
> > filename there... I understand this is undesirable, but what can I put
> > there instead?  Is "OpenRISC Linux" acceptable, or is nothing at all
> > preferable?
> > 
> > Just want to be clear about what's allowed before I go changing all of
> > these...
> 
> You don't really need anything in the comment, if you want to put something
> there, I'd recommend a one-line summary of what the file is used for.
> 

No license information, copyright, etc?  Nothing?  Would it be
preferable to delete the comments altogether...?

/Jonas

