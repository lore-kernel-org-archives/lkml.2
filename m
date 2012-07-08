Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab2GHIgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 04:36:46 -0400
Received: from Mailrelay020.isp.belgacom.be ([195.238.6.95]:31669 "EHLO
	mailrelay020.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab2GHIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 04:36:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAFpG+U9XQAxf/2dsb2JhbABFt1yBCIIgAQEFViIBEAsYCRYPCQMCAQIBDxgeBg0BBQIBAYd6AxCvPQ2JTopaZoYMA5ZIhESFLoUBgmE
Message-ID: <4FF94689.3050701@computer.org>
Date: Sun, 08 Jul 2012 10:36:25 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Toshiaki Yamane <yamanetoshi@gmail.com>
CC: greg@kroah.com, sjakub@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix checkpatch.pl issue.
References: <1341735405-16997-1-git-send-email-yamanetoshi@gmail.com>
In-Reply-To: <1341735405-16997-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2012 10:16 AM, Toshiaki Yamane wrote:
> -printk(KERN_ERR, to pr_err(...
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>

Hi

I submit that your subject line should be more descriptive. Perhaps
something like the following:

[PATCH] asus_oled: Use pr_err(...) rather than printk(KERN_ERR ...)

The rest of your commit message could then clarify that this change was
inspired by checkpatch.

HTH, Jan
