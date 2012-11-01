Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151Ab2KAWoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:44:12 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:47323 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab2KAWoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:44:09 -0400
Date: Thu, 1 Nov 2012 23:21:13 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: davem@davemloft.net
Cc: Cyril Brulebois <kibi@debian.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Hayes Wang <hayeswang@realtek.com>,
        linux-kernel@vger.kernel.org, florent.fourcot@enst-bretagne.fr
Subject: Re: [PATCH v2] r8169: Fix WoL on RTL8168d/8111d.
Message-ID: <20121101222113.GB7708@electric-eye.fr.zoreil.com>
References: <20121028230523.GA26778@electric-eye.fr.zoreil.com> <1351728046-32105-1-git-send-email-kibi@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351728046-32105-1-git-send-email-kibi@debian.org>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyril Brulebois <kibi@debian.org> :
> This regression was spotted between Debian squeeze and Debian wheezy
> kernels (respectively based on 2.6.32 and 3.2). More info about
> Wake-on-LAN issues with Realtek's 816x chipsets can be found in the
> following thread: http://marc.info/?t=132079219400004

David, please apply to -net.

Thanks.

-- 
Ueimor
