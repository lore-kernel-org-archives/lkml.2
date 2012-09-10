Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2IJSRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:17:52 -0400
Received: from host2.bln.innominate.com ([77.245.32.75]:42819 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2IJSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:17:50 -0400
Date: Mon, 10 Sep 2012 20:17:47 +0200
From: Lutz Jaenicke <ljaenicke@innominate.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lxt PHY: Support for the buggy LXT973 rev A2
Message-ID: <20120910181747.GA5960@lutz.bln.innominate.local>
Mail-Followup-To: Christophe Leroy <christophe.leroy@c-s.fr>,
	David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <201209101545.q8AFjn7u021483@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201209101545.q8AFjn7u021483@localhost.localdomain>
Organization: Innominate Security Technologies AG
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:45:49PM +0200, Christophe Leroy wrote:
> This patch adds proper handling of the buggy revision A2 of LXT973 phy, adding
> precautions linked to ERRATA Item 4:
> 
> Item 4: MDIO Interface and Repeated Polling
> Problem: Repeated polling of odd-numbered registers via the MDIO interface
> 	randomly returns the contents of the previous even register.
> Implication: Managed applications may not obtain the correct register contents
> 	when a particular register is monitored for device status.
> Workaround: None.
> Status: This erratum has been previously fixed (in rev A3)

Hmm. Were did you get the hardware from? We have been using LXT973 in
our products and the A2 was replaced by A3 in 2003.

Best regards,
	Lutz
-- 
Dr.-Ing. Lutz Jänicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.921028-200
fax: +49.30.921028-020
Rudower Chaussee 13
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Christoph Leifer
