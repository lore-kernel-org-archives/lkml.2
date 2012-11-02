Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2KBOfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:35:03 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54202 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2KBOe7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 2 Nov 2012 10:34:59 -0400
Message-Id: <5093E84C02000078000A619F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 14:35:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] xen-pciback: parsing improvements
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1: simplify and tighten parsing of device IDs
2: reject out of range inputs

Signed-off-by: Jan Beulich <jbeulich@suse.com>

