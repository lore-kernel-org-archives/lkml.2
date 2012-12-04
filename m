Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2LDPy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:54:58 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:45760 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752912Ab2LDPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:54:53 -0500
Date: Tue, 4 Dec 2012 16:54:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] MIPS: Avoid Machine Check by flushing entire page range
 in huge_ptep_set_access_flags().
Message-ID: <20121204155446.GA19472@linux-mips.org>
References: <1354567466-23571-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354567466-23571-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 12:44:26PM -0800, David Daney wrote:

Looks good and has survived my testing so far.  Applied.

Thanks David!

  Ralf
