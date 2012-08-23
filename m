Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab2HWNPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 09:15:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34996 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2HWNPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:15:01 -0400
Date: Thu, 23 Aug 2012 14:14:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Sebastian =?iso-8859-1?Q?P=F6hn?= <sebastian.poehn@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] dell-laptop: Caused by "Remove rfkill code" commit
Message-ID: <20120823131458.GA18067@srcf.ucam.org>
References: <1345726401.1481.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345726401.1481.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:53:21PM +0200, Sebastian Pöhn wrote:

> As rfkill can not get the state of the physical kill-switch, both state may differ.

b43 should know the state of the physical rfkill switch even if there's 
no platform code to support it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
