Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0DZO4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:56:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55868 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab0DZO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:56:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BD5A974.2080501@s5r6.in-berlin.de>
Date: Mon, 26 Apr 2010 16:55:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] firewire: ohci: add MSI support
References: <4BD5667B.1030900@ladisch.de> <4BD5A6C0.3030704@s5r6.in-berlin.de>
In-Reply-To: <4BD5A6C0.3030704@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Does "MSI 00", "MSI: Enable-" mean they do or don't support MSI?  Asks a
> PCIe newbie.

OK, an online encyclopedia informs me that MSI or MSI-X is required by PCIe.
-- 
Stefan Richter
-=====-==-=- -=-- ==-=-
http://arcgraph.de/sr/
