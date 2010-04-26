Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0DZJ0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:26:55 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:52671 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0DZJ0y convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Mon, 26 Apr 2010 05:26:54 -0400
Message-Id: <4BD5787C020000780003C1DB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 26 Apr 2010 10:26:52 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <eric@anholt.net>, <Brice.Goglin@ens-lyon.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: intel_i830_chipset_flush(): local clflush() vs. global
	 wbinvd()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, Brice,

what is the point of issuing wbinvd() on all CPUs here if clflush isn't
available, but using clflush() (if available) only on the current CPU?

Thanks, Jan

