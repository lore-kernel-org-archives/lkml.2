Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0LAQzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:55:22 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40602 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab0LAQzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:55:21 -0500
Date: Wed, 1 Dec 2010 16:55:17 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Fix build failure on mips_sc_is_activated()
Message-ID: <20101201165517.GA5560@linux-mips.org>
References: <1291221282-9056-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291221282-9056-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 01:34:42AM +0900, Namhyung Kim wrote:

> The commit ea31a6b20371 ("MIPS: Honor L2 bypass bit") breaks
> malta build as follows. Looks like not compile-tested :(

Already fixed in the linux-mips git tree by an identical patch in
commit 9a3475880131752d3d78ac25516fd3eab3fca871.

Thanks anyway!

  Ralf
