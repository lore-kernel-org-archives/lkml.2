Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0CaGqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 02:46:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34484
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab0CaGqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:46:11 -0400
Date: Tue, 30 Mar 2010 23:46:11 -0700 (PDT)
Message-Id: <20100330.234611.50622716.davem@davemloft.net>
To: wg@grandegger.com
Cc: iws@ovro.caltech.edu, linux-kernel@vger.kernel.org,
       socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN module
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BB1B2DA.60002@grandegger.com>
References: <1269881932-3803-3-git-send-email-iws@ovro.caltech.edu>
	<4BB1B2DA.60002@grandegger.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Tue, 30 Mar 2010 10:14:18 +0200

> Ira W. Snyder wrote:
>> The Janz VMOD-ICAN3 is a MODULbus daughterboard which fits onto any
>> MODULbus carrier board. It is an intelligent CAN controller with a
>> microcontroller and associated firmware.
>> 
>> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> 
> Acked-by: Wolfgang Grandegger <wg@grandegger.com>

Since this driver depends upon the MFD stuff and that goes
through other maintainers, just toss this CAN driver in
via whatever tree the MFD thing goes through and add my:

Acked-by: David S. Miller <davem@davemloft.net>

Thanks!
