Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1CGUQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:16:19 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:56065 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab1CGUQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:16:17 -0500
Date: Mon, 7 Mar 2011 21:16:10 +0100
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: Re: [PATCH] [SCSI] bnx2fc: fix build error when !CONFIG_MODULES
Message-ID: <20110307201610.GA9032@mako-laptop>
References: <20110302182740.e4dfd79f.sfr@canb.auug.org.au>
 <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1299103803-32594-1-git-send-email-mk@lab.zgora.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 11:10:03PM +0100, Mariusz Kozlowski wrote:
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: dereferencing pointer to incomplete type
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1815: error: ‘MODULE_STATE_LIVE’ undeclared (first use in this function)

Hm. Still there in next-20110307. Is this patch wrong or..?

-- 
Mariusz Kozlowski
