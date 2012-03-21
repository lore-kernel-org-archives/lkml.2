Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab2CULTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 07:19:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52645 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab2CULTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 07:19:20 -0400
Date: Wed, 21 Mar 2012 11:19:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Azael Avalos <coproscefalo@gmail.com>
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
Message-ID: <20120321111917.GB26854@srcf.ucam.org>
References: <20120321165204.3b9e1995dc363b685d8018dc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321165204.3b9e1995dc363b685d8018dc@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damnit. Sorry, I fixed up the for-linus branch but failed to carry that 
over to next. Not Seth's fault, I screwed up when hand-merging his 
patch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
