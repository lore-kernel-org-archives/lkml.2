Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2J2U05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:26:57 -0400
Received: from shutemov.name ([176.9.204.213]:60025 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab2J2U04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:26:56 -0400
Date: Mon, 29 Oct 2012 22:28:20 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Chris Ball <cjb@laptop.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Irina Tirdea <irina.tirdea@intel.com>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 00/26] pstore, mmc: add mmc as backend for pstore
Message-ID: <20121029202820.GA21660@shutemov.name>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 04:47:58PM +0300, Irina Tirdea wrote:
> These patches enable using the mmc card to store panic information.
> 
> They include changes for pstore and mmc:
>  - add block device backend for pstore
>  - add logic in mmc for writing in panic mode

Chris, any feedback on mmc/sdhci part?

-- 
 Kirill A. Shutemov
