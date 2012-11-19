Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab2KSCzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:55:49 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:60998 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KSCzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:55:48 -0500
Date: Mon, 19 Nov 2012 00:55:40 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: btrfs crash - Null dereference - 3.7.0-rc5-00068-gc5e35d6
Message-ID: <20121119025540.GA3858@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my system suddenly crashed and gave me this dump:

http://imgur.com/oO6S0

I checked and there is not btrfs commit in linus' tree since I compiled this
kernel.

	Gustavo
