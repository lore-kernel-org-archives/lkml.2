Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab2KLQjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:39:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58706 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab2KLQjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:39:07 -0500
Date: Mon, 12 Nov 2012 08:38:58 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: davem@davemloft.net, stable@vger.kernel.org,
        Cyril Brulebois <kibi@debian.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Hayes Wang <hayeswang@realtek.com>,
        linux-kernel@vger.kernel.org, florent.fourcot@enst-bretagne.fr
Subject: [3.0.y, 3.2.y, 3.4.y] Re: [PATCH v2] r8169: Fix WoL on
 RTL8168d/8111d.
Message-ID: <20121112163858.GA4343@elie.Belkin>
References: <20121028230523.GA26778@electric-eye.fr.zoreil.com>
 <1351728046-32105-1-git-send-email-kibi@debian.org>
 <20121101222113.GB7708@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20121101222113.GB7708@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Cyril Brulebois <kibi@debian.org> :

>> This regression was spotted between Debian squeeze and Debian wheezy
>> kernels (respectively based on 2.6.32 and 3.2). More info about
>> Wake-on-LAN issues with Realtek's 816x chipsets can be found in the
>> following thread: http://marc.info/?t=132079219400004
>
> David, please apply to -net.

This has been applied as commit b00e69dee4cc in mainline; thanks!

François and David, would this be a candidate for inclusion in
3.0- and newer stable kernels?

Jonathan
