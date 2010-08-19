Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0HSLBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:01:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46917 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0HSLBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:01:51 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "markus.lehtonen@nokia.com" <markus.lehtonen@nokia.com>,
        "roger.quadros@nokia.com" <roger.quadros@nokia.com>
Date: Thu, 19 Aug 2010 16:29:05 +0530
Subject: RE: [PATCH] power_supply: add isp1704 charger detection driver
Thread-Topic: [PATCH] power_supply: add isp1704 charger detection driver
Thread-Index: Acs+1Zupo72LQxe4QmWxIsO5t+p1WgAt7xcQ
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB032422290C@dbde02.ent.ti.com>
References: <1282136465-1748-1-git-send-email-ext-heikki.krogerus@nokia.com>
In-Reply-To: <1282136465-1748-1-git-send-email-ext-heikki.krogerus@nokia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void isp1704_charger_work(struct work_struct *data)
> +{
> +	struct isp1704_charger	*isp =
> +		container_of(data, struct isp1704_charger, work);
> +
> +	/* FIXME Only supporting dedicated chargers even though isp1704 can
> +	 * detect HUB and HOST chargers. If the device has already been
> +	 * enumerated, the detection will break the connection.
> +	 */

Minor CodingStyle comment (since you're reworking the patch anyway).

Preferred style for multi-line comments is:

/*
 * FIXME Only supporting ...
 * detect HUB ...
 * enumerated ...
 */

