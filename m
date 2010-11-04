Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0KDK0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 06:26:18 -0400
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:32922 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0KDK0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 06:26:16 -0400
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 06:26:16 EDT
Message-ID: <4CD28529.1030606@csr.com>
Date: Thu, 04 Nov 2010 10:04:25 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
References: <1288850351.3429.2.camel@mola>
In-Reply-To: <1288850351.3429.2.camel@mola>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: david.vrabel@csr.com
Subject: Re: [PATCH] mmc: Return proper error code for ushc_probe()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:20:07 +0000)
X-SA-Exim-Scanned: Yes (on pear.davidvrabel.org.uk)
X-Originating-Smarthost01-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2010 05:59, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks.

Acked-by: David Vrabel <david.vrabel@csr.com>

Chris, queue this one up for 2.6.37 please.

David
