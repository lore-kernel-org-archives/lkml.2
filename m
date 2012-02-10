Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2BJPog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:44:36 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52520 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2BJPof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:44:35 -0500
Date: Fri, 10 Feb 2012 15:44:23 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dzickus@redhat.com, vgoyal@redhat.com, seiji.aguchi@hds.com
Subject: Re: [PATCH] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120210154423.GA31977@srcf.ucam.org>
References: <1328886693-20670-1-git-send-email-mjg@redhat.com>
 <4F353964.1000405@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F353964.1000405@fastmail.fm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh. Is there any way to get git send-email to warn when you have a 
dirty tree?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
