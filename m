Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab0LFF66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:58:58 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:63917 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0LFF65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:58:57 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=iIBNOEVUjEDkhEOh/abAIYs0g4mYzTJnKEtQlRLTvBn8pNd77mNuliYk6mJaIEHN00IytqYne3aQuUMIDgDg5bprTV8MAKYPYhOaUy7YyqzlwHhxqfYzyElWoN9El5BHdVpueAc/EkZnX10QS8BY64DOJOtyYEJyZl3A8sIEv+s=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Proposal to add dynamic debug feature for print_hex_dump [2/2]
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.4-default; KDE/4.5.3; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de> <201012031521.41332.roman.fietze@telemotive.de> <1291408621.1815.46.camel@Joe-Laptop>
In-Reply-To: <1291408621.1815.46.camel@Joe-Laptop>
MIME-Version: 1.0
Message-ID: <201012060658.51464.roman.fietze@telemotive.de>
Date: Mon, 6 Dec 2010 06:58:51 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 06.12.2010 06:58:51,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 06.12.2010 06:58:52,
	Serialize complete at 06.12.2010 06:58:52
Content-Transfer-Encoding: 7bit
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On Friday 03 December 2010 21:37:00 Joe Perches wrote:

> I think this should be dynamic_pr_debug_hex_dump and

No problem, I see your point.

> ...
> to mirror the print_hex_dump args.

Accepted. I shortened the names to shorten the macros (numer of
lines), but changing this back to the old names isn't a problem.

No longer offering the warning-version and just the warn-version is no
problem as well.

I will incoroprate your proposals into a new set of patches and offer
theme here, when I got Jason's response ... or a timeout.


Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
