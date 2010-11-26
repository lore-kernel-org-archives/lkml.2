Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0KZNRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:17:30 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39710 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0KZNR3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Fri, 26 Nov 2010 08:17:29 -0500
Message-Id: <4CEFC1AA0200007800024734@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 26 Nov 2010 13:18:18 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <dsd@laptop.org>
Cc: <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: your patch "x86, olpc: Rework BIOS signature check"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... adds a select of OLPC_OPENFIRMWARE to the OLPC option,
which contradicts OLPC_OPENFIRMWARE itself depending on
!X86_64 && !X86_PAE. Are the latter dependencies not necessary
anymore (the X86_64 one wasn't very meaningful anyway, since
these options all sit inside a "if X86_32"), or should the select be
conditional?

Also, how meaningful is having OLPC_OPENFIRMWARE on but OLPC
off (i.e. can OLPC_OPENFIRMWARE perhaps go away altogether)?

Thanks, Jan

