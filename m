Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab1FQLuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:50:19 -0400
Received: from lo.gmane.org ([80.91.229.12]:56864 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab1FQLuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:50:16 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
Subject: Re: [3.0-rc3] tree RCU boost vs hang notifier...
Date: Fri, 17 Jun 2011 11:44:02 +0000 (UTC)
Message-ID: <pan.2011.06.17.11.44.00@message-id.slipkonture.de>
References: <BANLkTin2osfkSiu8maGmJAnzv4O5ODK0dw@mail.gmail.com>
	<20110614045150.GA2264@linux.vnet.ibm.com>
	<BANLkTinvygi9aSkFcnOs2CHCmExD2ixJuQ@mail.gmail.com>
	<20110614124048.GB2264@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 155.56.40.13
User-Agent: Pan/0.134 (Wait for Me; GIT cb32159 master)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 05:40:48 -0700, Paul E. McKenney wrote:

> On Tue, Jun 14, 2011 at 01:46:04PM +0800, Daniel J Blueman wrote:
>> Tested-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> Thank you very much for testing this!

Hi Paul,

Will this also fix the constant system load of 1.0 or is this a different 
issue? (If it was, I'd need to report it properly ;)

Best regards,

	Stefan

