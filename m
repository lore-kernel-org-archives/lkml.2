Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2KLX1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:27:46 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:42782 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2KLX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:27:45 -0500
Date: Tue, 13 Nov 2012 00:03:39 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: davem@davemloft.net, stable@vger.kernel.org,
        Cyril Brulebois <kibi@debian.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Hayes Wang <hayeswang@realtek.com>,
        linux-kernel@vger.kernel.org, florent.fourcot@enst-bretagne.fr
Subject: Re: [3.0.y, 3.2.y, 3.4.y] Re: [PATCH v2] r8169: Fix WoL on RTL8168d/8111d.
Message-ID: <20121112230339.GA28555@electric-eye.fr.zoreil.com>
References: <20121028230523.GA26778@electric-eye.fr.zoreil.com> <1351728046-32105-1-git-send-email-kibi@debian.org> <20121101222113.GB7708@electric-eye.fr.zoreil.com> <20121112163858.GA4343@elie.Belkin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112163858.GA4343@elie.Belkin>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder <jrnieder@gmail.com> :
[...]
> This has been applied as commit b00e69dee4cc in mainline; thanks!
> 
> Fran??ois and David, would this be a candidate for inclusion in
> 3.0- and newer stable kernels?

- 3.0.51
  b00e69dee4ccbb3a19989e3d4f1385bc2e3406cd
  aee77e4accbeb2c86b1d294cd84fec4a12dde3bd

- 3.4.18
  0481776b7a70f09acf7d9d97c288c3a8403fbfe4
  b00e69dee4ccbb3a19989e3d4f1385bc2e3406cd
  aee77e4accbeb2c86b1d294cd84fec4a12dde3bd

- 3.6.6
  0481776b7a70f09acf7d9d97c288c3a8403fbfe4
  b00e69dee4ccbb3a19989e3d4f1385bc2e3406cd
  aee77e4accbeb2c86b1d294cd84fec4a12dde3bd

I'll cook the patches.

-- 
Ueimor
