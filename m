Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0F2Rng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:43:36 -0400
Received: from cheetah.host-care.com ([66.7.219.192]:41643 "EHLO
	cheetah.host-care.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab0F2Rnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:43:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding:X-Source:X-Source-Args:X-Source-Dir;
	b=qB4NMvcujT8B8C0lBiSdaeXZ3I49puDJSC9P+q3oHb59VkNrf2EbOWKtK2LTezZCL5lr9KOND2WNFDqJL3cQ4/4qY8eMUXlzl/HJj+TQz6+qWm7JEPAQNeX2O8XoXbaH;
Subject: Re: [PATCH] Expose vendor-specific ACM channel on Nokia 5230
From: Przemo Firszt <przemo@firszt.eu>
To: Oliver Neukum <oliver@neukum.org>
Cc: oliver@neukum.name, gregkh@suse.de, alan@linux.intel.com,
       francescolavra@interfree.it, julian.calaby@gmail.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201006282259.11598.oliver@neukum.org>
References: <1277756974-3373-1-git-send-email-przemo@firszt.eu>
	 <201006282259.11598.oliver@neukum.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 18:43:23 +0100
Message-ID: <1277833403.4123.2.camel@pldmachine>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 PLD Linux 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cheetah.host-care.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2010-06-28, pon o godzinie 22:59 +0200, Oliver Neukum pisze:
> Am Montag, 28. Juni 2010, 22:29:34 schrieb Przemo Firszt:
> > Nokia S60 phones expose two ACM channels. The first is
> > a modem, the second is 'vendor-specific' but is treated
> > as a serial device at the S60 end, so we want to expose
> > it on Linux too.
> > 
> 
> I see. We want to expose it. But do we want to expose it as an acm interface?
> 
> 	Regards
> 		Oliver
It's just continuation of [1]. I don't feel pressure to do it that way
if there are any better ideas.

[1] http://article.gmane.org/gmane.linux.kernel.commits.head/221222
-- 
Kind regards,
Przemo Firszt 

