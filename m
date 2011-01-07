Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1AGWdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:33:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35373 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab1AGWdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:33:38 -0500
Date: Fri, 7 Jan 2011 22:33:33 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [RFC PATCH] platform/x86: add MXM WMI driver.
Message-ID: <20110107223333.GA1006@srcf.ucam.org>
References: <1292901555-16213-1-git-send-email-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292901555-16213-1-git-send-email-airlied@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you looking for this to be merged at the moment? If so, the printks 
probably ought to be conditional on a debug parameter (is the drm debug 
level exported?).

-- 
Matthew Garrett | mjg59@srcf.ucam.org
