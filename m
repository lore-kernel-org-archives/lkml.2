Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2AELnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:43:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2AELn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:43:29 -0500
Date: Thu, 5 Jan 2012 12:43:15 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] rtlwifi: Standardize RT_PRINT_DATA macro and uses
Message-ID: <20120105114314.GD2222@redhat.com>
References: <cover.1325734202.git.joe@perches.com>
 <e7d4163a9897f33145d8a07be54f507ab68e0243.1325734203.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d4163a9897f33145d8a07be54f507ab68e0243.1325734203.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe

On Wed, Jan 04, 2012 at 07:40:40PM -0800, Joe Perches wrote:
>  	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,

Since you are working on it, can you also get rid of this DBG_*
parameter, if rtlwifi maintainers are ok with that? It is additional
console loglvevel, standard kernel loglevel should be used.

Thanks
Stanislaw
